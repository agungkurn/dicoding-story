import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

part 'choose_location_bloc.freezed.dart';
part 'choose_location_event.dart';
part 'choose_location_state.dart';

@injectable
class ChooseLocationBloc
    extends Bloc<ChooseLocationEvent, ChooseLocationState> {
  final newLocationMarkerId = MarkerId("new-location");
  final userLocationMarkerId = MarkerId("my-location");

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
      final newLatLng = LatLng(lat, lng);
      final marker = Marker(
        markerId: newLocationMarkerId,
        position: newLatLng,
        onTap: () {
          add(ChooseLocationEvent.onMarkerCleared());
        },
      );

      emit(
        state.copyWith(
          newLocation: newLatLng,
          locationName: location,
          markers: {...state.markers, marker},
        ),
      );
    });
    on<_MarkerCleared>((event, emit) {
      final markers = {...state.markers}
        ..retainWhere((marker) => marker.markerId == userLocationMarkerId);
      emit(
        state.copyWith(newLocation: null, locationName: null, markers: markers),
      );
    });
    on<_DetectUserLocation>((event, emit) async {
      if (state.userLocation != null) {
        emit(state.copyWith(moveCameraToUserLocation: true));
      } else {
        final location = await _getUserLocation();
        if (location == null) return;

        final marker = Marker(
          markerId: userLocationMarkerId,
          position: location,
          icon: await _createBitmapDescriptorFromCupertinoIcon(
            CupertinoIcons.location_circle_fill,
          ),
        );
        emit(
          state.copyWith(
            markers: {...state.markers, marker},
            userLocation: location,
            moveCameraToUserLocation: event.moveCamera,
          ),
        );
      }
    });
    on<_CameraMovedToUserLocation>((event, emit) {
      emit(state.copyWith(moveCameraToUserLocation: false));
    });
  }

  Future<bool> _hasLocationAccess(Location location) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<LatLng?> _getUserLocation() async {
    final location = Location();

    final hasLocationAccess = await _hasLocationAccess(location);
    if (hasLocationAccess) {
      LocationData locationData = await location.getLocation();
      final latLng = LatLng(locationData.latitude!, locationData.longitude!);
      return latLng;
    }

    return null;
  }

  Future<BitmapDescriptor> _createBitmapDescriptorFromCupertinoIcon(
    IconData iconData, {
    Color color = CupertinoColors.systemBlue,
    double size = 32,
  }) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: color,
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final image = await pictureRecorder.endRecording().toImage(
      textPainter.width.ceil(),
      textPainter.height.ceil(),
    );

    final bytes = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }
}
