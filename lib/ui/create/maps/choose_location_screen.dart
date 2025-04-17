import 'package:dicoding_story/navigation/app_route.dart';
import 'package:dicoding_story/ui/create/maps/choose_location_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseLocationScreen extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  ChooseLocationScreen({super.key, this.latitude, this.longitude});

  final defaultLatitude = -6.2088;
  final defaultLongitude = 106.8456;

  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final hasPreviousLocation = latitude != null && longitude != null;
    final blocRead =
        context.read<ChooseLocationBloc>()..add(
          ChooseLocationEvent.onDetectUserLocation(
            moveCamera: !hasPreviousLocation,
          ),
        );

    if (hasPreviousLocation) {
      blocRead.add(ChooseLocationEvent.onMarkerMoved(latitude!, longitude!));
    }

    return CupertinoPageScaffold(
      child: BlocConsumer<ChooseLocationBloc, ChooseLocationState>(
        listener: (context, state) {
          if (state.userLocation != null && state.moveCameraToUserLocation) {
            _controller?.animateCamera(
              CameraUpdate.newLatLng(state.userLocation!),
            );
            blocRead.add(ChooseLocationEvent.onCameraMovedToUserLocation());
          }
        },
        builder:
            (context, state) => Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _controller = controller;
                  },
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  markers: state.markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      latitude ?? defaultLatitude,
                      longitude ?? defaultLongitude,
                    ),
                    zoom: 15,
                  ),
                  onTap: (latLng) {
                    _controller?.animateCamera(CameraUpdate.newLatLng(latLng));
                    blocRead.add(
                      ChooseLocationEvent.onMarkerMoved(
                        latLng.latitude,
                        latLng.longitude,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                    child: CupertinoButton(
                      onPressed: () {
                        context.pop();
                      },
                      sizeStyle: CupertinoButtonSize.small,
                      color: CupertinoColors.systemBackground,
                      child: Icon(CupertinoIcons.back),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: SafeArea(
                    child: CupertinoButton.filled(
                      onPressed: () {
                        blocRead.add(
                          ChooseLocationEvent.onDetectUserLocation(),
                        );
                      },
                      sizeStyle: CupertinoButtonSize.small,
                      child: Icon(CupertinoIcons.scope),
                    ),
                  ),
                ),
                state.newLocation != null
                    ? Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: SafeArea(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CupertinoDynamicColor.resolve(
                              CupertinoColors.systemBackground,
                              context,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            spacing: 16,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: CupertinoButton(
                                  sizeStyle: CupertinoButtonSize.small,
                                  onPressed: () {
                                    blocRead.add(
                                      ChooseLocationEvent.onMarkerCleared(),
                                    );
                                  },
                                  child: Icon(
                                    CupertinoIcons.clear,
                                    color: CupertinoColors.systemRed,
                                  ),
                                ),
                              ),
                              Text(
                                state.locationName!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CupertinoButton.filled(
                                sizeStyle: CupertinoButtonSize.medium,
                                child: Text("Pilih Lokasi"),
                                onPressed: () {
                                  _onSelectLocation(
                                    context,
                                    state.newLocation!,
                                    state.locationName!,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : SizedBox.shrink(),
              ],
            ),
      ),
    );
  }

  void _onSelectLocation(
    BuildContext context,
    LatLng location,
    String locationName,
  ) {
    final result = {
      AppRoute.mapLatitude: location.latitude,
      AppRoute.mapLongitude: location.longitude,
      AppRoute.mapAddress: locationName,
    };
    context.pop(result);
  }
}
