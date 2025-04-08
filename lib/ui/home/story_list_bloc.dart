import 'package:dicoding_story/data/model/response/story.dart';
import 'package:dicoding_story/data/repository/story_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/remote/display_exception.dart';

part 'story_list_bloc.freezed.dart';
part 'story_list_event.dart';
part 'story_list_state.dart';

@injectable
class StoryListBloc extends Bloc<StoryListEvent, StoryListState> {
  final StoryRepository _repository;

  StoryListBloc(this._repository) : super(StoryListState.idle()) {
    on<_FetchList>((event, emit) async {
      emit(StoryListState.loading());

      try {
        final result = await _repository.getAllStories();
        emit(StoryListState.success(result));
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(StoryListState.error(msg));
      }
    });
  }
}
