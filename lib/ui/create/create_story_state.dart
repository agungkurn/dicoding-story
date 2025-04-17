part of 'create_story_bloc.dart';

@freezed
abstract class CreateStoryState with _$CreateStoryState {
  const factory CreateStoryState({
    required XFile? image,
    required String description,
    required bool imageIsEmpty,
    required bool descriptionIsEmpty,
    required String? location,
    required double? latitude,
    required double? longitude,
    required bool loading,
    required bool success,
    required bool error,
    required String? errorMessage,
  }) = _CreateStoryState;

  factory CreateStoryState.initial() => const CreateStoryState(
    image: null,
    description: "",
    imageIsEmpty: false,
    descriptionIsEmpty: false,
    location: null,
    latitude: null,
    longitude: null,
    loading: false,
    success: false,
    error: false,
    errorMessage: null,
  );
}

extension CreateStoryStateExtension on CreateStoryState {
  bool get canSubmit => image != null && description.trim().isNotEmpty;
}
