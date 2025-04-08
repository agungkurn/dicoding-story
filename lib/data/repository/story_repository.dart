import 'package:dicoding_story/data/remote/story_api.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../model/response/story.dart';

@injectable
class StoryRepository {
  final StoryApi _api;

  StoryRepository(this._api);

  Future<List<Story>> getAllStories({
    int page = 1,
    int size = 10,
    int location = 0,
  }) async {
    try {
      final result = await _api.getAllStories(page, size, location);
      return result.listStory;
    } catch (e, stack) {
      if (kDebugMode) print(stack);
      rethrow;
    }
  }

  Future<Story> getStoryDetails(String id) async {
    try {
      final result = await _api.getStoryDetails(id);
      return result.story;
    } catch (e, stack) {
      if (kDebugMode) print(stack);
      rethrow;
    }
  }

  Future<void> uploadStory({
    required List<int> bytes,
    required String fileName,
    required String description,
  }) async {
    try {
      await _api.postStory(
        bytes: bytes,
        fileName: fileName,
        description: description,
      );
    } catch (e, stack) {
      if (kDebugMode) print(stack);
      rethrow;
    }
  }
}
