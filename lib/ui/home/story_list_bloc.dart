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

  int? _page = 1;
  final int _size = 10;

  StoryListBloc(this._repository) : super(StoryListState.initial()) {
    on<_FetchList>((event, emit) async {
      if (state.loading) return;

      _page = 1;

      emit(
        state.copyWith(
          loading: true,
          loadingNextPage: false,
          error: false,
          errorMessage: null,
        ),
      );

      try {
        final newItems = await _repository.getAllStories(page: 1, size: _size);

        emit(
          state.copyWith(
            stories: newItems,
            loading: false,
            hasNextPage: newItems.length == _size,
          ),
        );
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(state.copyWith(error: true, errorMessage: msg));
      }
    });
    on<_FetchNextPage>((event, emit) async {
      if (state.loadingNextPage) return;

      emit(
        state.copyWith(loadingNextPage: true, error: false, errorMessage: null),
      );

      try {
        final newItems = await _repository.getAllStories(
          page: _page!,
          size: _size,
        );

        if (newItems.length < _size) {
          _page = null;
        } else {
          _page = _page! + 1;
        }

        emit(
          state.copyWith(
            stories: [...state.stories, ...newItems],
            loading: false,
            loadingNextPage: false,
            hasNextPage: _page != null,
          ),
        );
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(state.copyWith(error: true, errorMessage: msg));
      }
    });
  }
}
