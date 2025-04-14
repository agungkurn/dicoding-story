import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

part 'choose_location_bloc.freezed.dart';
part 'choose_location_event.dart';
part 'choose_location_state.dart';

@injectable
class ChooseLocationBloc
    extends Bloc<ChooseLocationEvent, ChooseLocationState> {
  ChooseLocationBloc() : super(ChooseLocationState.initial()) {
    on<_MarkerMoved>((event, emit) async {
      final lat = event.latitude;
      final lng = event.longitude;

      final placemark = await geo.placemarkFromCoordinates(lat, lng);
      final place = placemark[0];
      final location = {
        place.name,
        place.thoroughfare,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.country,
      }.where((s) => s != null && s.isNotEmpty).join(", ");
      final markers = {
        Marker(markerId: MarkerId("marker"), position: LatLng(lat, lng)),
      };

      emit(
        state.copyWith(
          latitude: lat,
          longitude: lng,
          location: location,
          markers: markers,
        ),
      );
    });
    on<_MarkerCleared>((event, emit) {
      emit(
        state.copyWith(
          latitude: null,
          longitude: null,
          location: null,
          markers: {},
        ),
      );
    });
  }
}
