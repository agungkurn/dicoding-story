part of 'create_story_bloc.dart';

@freezed
abstract class CreateStoryEvent with _$CreateStoryEvent {
  const factory CreateStoryEvent.addImage(XFile image) = _AddImage;

  const factory CreateStoryEvent.removeImage() = _RemoveImage;

  const factory CreateStoryEvent.locationAdded(
    String location,
    double latitude,
    double longitude,
  ) = _LocationAdded;

  const factory CreateStoryEvent.onDescriptionChanges(String data) =
      _OnDescriptionChanges;

  const factory CreateStoryEvent.onSubmit() = _OnSubmit;
}
