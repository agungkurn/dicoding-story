part of 'story_list_bloc.dart';

@freezed
class StoryListState with _$StoryListState {
  const factory StoryListState.idle() = StoryListIdle;

  const factory StoryListState.loading() = StoryListLoading;

  factory StoryListState.success(List<Story> stories) = StoryListSuccess;

  const factory StoryListState.error(String? message) = StoryListError;
}
