part of 'story_list_bloc.dart';

@freezed
abstract class StoryListState with _$StoryListState {
  const factory StoryListState({
    required List<Story> stories,
    required bool loading,
    required bool loadingNextPage,
    required bool hasNextPage,
    required bool error,
    required String? errorMessage,
  }) = _StoryListState;

  factory StoryListState.initial() => StoryListState(
    stories: [],
    loading: false,
    loadingNextPage: false,
    hasNextPage: false,
    error: false,
    errorMessage: null,
  );
}
