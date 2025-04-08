import 'package:dicoding_story/data/repository/story_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/response/story.dart';
import '../../data/remote/display_exception.dart';

part 'details_bloc.freezed.dart';

part 'details_event.dart';

part 'details_state.dart';

@injectable
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final StoryRepository _repository;

  DetailsBloc(this._repository) : super(DetailsState.idle()) {
    on<_FetchDetails>((event, emit) async {
      emit(DetailsState.loading());

      try {
        final result = await _repository.getStoryDetails(event.id);
        emit(DetailsState.success(story: result));
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(DetailsState.error(msg));
      }
    });
    on<_ToggleDescription>((event, emit) async {
      if (state is DetailsSuccess) {
        final successState = state as DetailsSuccess;
        emit(successState.copyWith(textExpanded: !successState.textExpanded));
      }
    });
  }
}
