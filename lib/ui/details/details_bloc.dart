import 'package:dicoding_story/data/repository/story_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart' as geo;
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

        if (result.lat != null && result.lon != null) {
          final placemark = await geo.placemarkFromCoordinates(
            result.lat!,
            result.lon!,
          );
          final place = placemark[0];

          final fullAddress = [
            place.name,
            place.thoroughfare,
            place.subAdministrativeArea,
            place.administrativeArea,
            place.country,
          ].where((s) => s != null && s.isNotEmpty).join(", ");
          emit(DetailsState.success(story: result, address: fullAddress));
        } else {
          emit(DetailsState.success(story: result, address: null));
        }
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
