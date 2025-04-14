part of 'choose_location_bloc.dart';

@freezed
abstract class ChooseLocationState with _$ChooseLocationState {
  const factory ChooseLocationState({
    required LatLng? newLocation,
    required LatLng? userLocation,
    required String? locationName,
    required bool moveCameraToUserLocation,
    required Set<Marker> markers,
  }) = _ChooseLocationState;

  factory ChooseLocationState.initial() => ChooseLocationState(
    newLocation: null,
    userLocation: null,
    locationName: null,
    moveCameraToUserLocation: false,
    markers: {},
  );
}
