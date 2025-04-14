import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailsMapsScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String address;

  const DetailsMapsScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(address, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      child: Center(
        child: GoogleMap(
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: MarkerId("address"),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: address),
            ),
          },
        ),
      ),
    );
  }
}
