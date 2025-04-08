import 'package:freezed_annotation/freezed_annotation.dart';
import 'story.dart';

part 'story_details_response.freezed.dart';
part 'story_details_response.g.dart';

@freezed
abstract class StoryDetailsResponse with _$StoryDetailsResponse {
  const factory StoryDetailsResponse({
    required bool error,
    required String message,
    required Story story,
  }) = _StoryDetailsResponse;

  factory StoryDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailsResponseFromJson(json);
}
