part of 'choose_location_bloc.dart';

@freezed
abstract class ChooseLocationEvent with _$ChooseLocationEvent {
  const factory ChooseLocationEvent.onMarkerMoved(
    double latitude,
    double longitude,
  ) = _MarkerMoved;

  const factory ChooseLocationEvent.onMarkerCleared() = _MarkerCleared;
}
