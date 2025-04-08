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

    print("parsed: $parsed");

    if (parsed.error) {
      throw DisplayException(parsed.message);
    } else {
      return parsed;
    }
  }
}
