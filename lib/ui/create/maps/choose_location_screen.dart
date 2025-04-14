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

  late final GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    final blocRead = context.read<ChooseLocationBloc>();

    return CupertinoPageScaffold(
      child: BlocBuilder<ChooseLocationBloc, ChooseLocationState>(
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
                    _controller.animateCamera(CameraUpdate.newLatLng(latLng));
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
                state.location != null && state.location!.isNotEmpty
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
                                state.location!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CupertinoButton.filled(
                                sizeStyle: CupertinoButtonSize.medium,
                                child: Text("Pilih Lokasi"),
                                onPressed: () {
                                  final result = {
                                    AppRoute.mapLatitude: state.latitude!,
                                    AppRoute.mapLongitude: state.longitude!,
                                    AppRoute.mapAddress: state.location!,
                                  };
                                  context.pop(result);
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
}
