import 'package:dicoding_story/data/model/response/story_details_response.dart';
import 'package:dicoding_story/data/model/response/upload_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../model/response/story_list_response.dart';
import 'display_exception.dart';

@injectable
class StoryApi {
  final Dio _dio;

  StoryApi(@Named("user") this._dio);

  Future<StoryListResponse> getAllStories(
    int page,
    int size,
    int location,
  ) async {
    final response = await _dio.get(
      "/stories",
      queryParameters: {"page": page, "size": size, "location": location},
    );
    final parsed = StoryListResponse.fromJson(response.data);

    if (parsed.error) {
      throw DisplayException(parsed.message);
    } else {
      return parsed;
    }
  }

  Future<StoryDetailsResponse> getStoryDetails(String id) async {
    final response = await _dio.get("/stories/$id");
    final parsed = StoryDetailsResponse.fromJson(response.data);

    if (parsed.error) {
      throw DisplayException(parsed.message);
    } else {
      return parsed;
    }
  }

  Future<UploadResponse> postStory({
    required List<int> bytes,
    required String fileName,
    required String description,
    double? latitude,
    double? longitude,
  }) async {
    final formData = FormData.fromMap({
      "description": description,
      "lat": latitude,
      "lon": longitude,
      "photo": MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: DioMediaType("image", "jpeg"),
      ),
    });

    final response = await _dio.post(
      "/stories",
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );
    final parsed = UploadResponse.fromJson(response.data);

    if (parsed.error) {
      throw DisplayException(parsed.message);
    } else {
      return parsed;
    }
  }
}
