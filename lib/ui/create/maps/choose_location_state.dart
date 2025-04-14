part of 'choose_location_bloc.dart';

@freezed
abstract class ChooseLocationState with _$ChooseLocationState {
  const factory ChooseLocationState({
    required double? latitude,
    required double? longitude,
    required String? location,
    required bool loadingLocation,
    required Set<Marker> markers,
  }) = _ChooseLocationState;

  factory ChooseLocationState.initial() => ChooseLocationState(
    latitude: null,
    longitude: null,
    location: null,
    loadingLocation: false,
    markers: {},
  );
}
