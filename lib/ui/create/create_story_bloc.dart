import 'package:dicoding_story/data/repository/story_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../data/remote/display_exception.dart';

part 'create_story_event.dart';

part 'create_story_state.dart';

part 'create_story_bloc.freezed.dart';

@injectable
class CreateStoryBloc extends Bloc<CreateStoryEvent, CreateStoryState> {
  final StoryRepository _repository;

  CreateStoryBloc(this._repository) : super(CreateStoryState.initial()) {
    on<_AddImage>((event, emit) {
      emit(state.copyWith(image: event.image, imageIsEmpty: false));
    });
    on<_RemoveImage>((event, emit) {
      emit(state.copyWith(image: null, imageIsEmpty: true));
    });
    on<_OnDescriptionChanges>((event, emit) {
      emit(
        state.copyWith(
          description: event.data,
          descriptionIsEmpty: event.data.trim().isEmpty,
        ),
      );
    });
    on<_OnSubmit>((event, emit) async {
      emit(state.copyWith(loading: true, error: false, errorMessage: null));

      try {
        if (state.image != null) {
          final bytes = await state.image!.readAsBytes();
          final compressed = await compute(_compressImage, bytes);

          await _repository.uploadStory(
            bytes: compressed,
            fileName: state.image?.name ?? "",
            description: state.description,
          );
        }
        emit(state.copyWith(loading: false, success: true));
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(state.copyWith(loading: false, error: true, errorMessage: msg));
      }
    });
  }
}

List<int> _compressImage(List<int> bytes) {
  int imageLength = bytes.length;
  if (imageLength < 1000000) return bytes;
  final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
  int compressQuality = 100;
  int length = imageLength;
  List<int> newByte = [];

  do {
    compressQuality -= 10;
    newByte = img.encodeJpg(image, quality: compressQuality);
    length = newByte.length;
  } while (length > 1000000);
  return newByte;
}
