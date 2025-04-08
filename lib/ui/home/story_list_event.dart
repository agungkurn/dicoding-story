part of 'story_list_bloc.dart';

@freezed
class StoryListEvent with _$StoryListEvent {
  const factory StoryListEvent.fetchList() = _FetchList;

  const factory StoryListEvent.openStoryDetails(String id) = _OpenStoryDetails;
}
