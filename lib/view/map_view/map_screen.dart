import 'package:flutter/material.dart';
import 'package:google_maps/view/map_view/provider/map_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'components/location_direction_services.dart';
import 'components/search_field.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key}); //, required this.networkInfo

  // NetworkInfo networkInfo;
  // final Completer<GoogleMapController> _controller = Completer();
  // final Marker _kLakeMarker = const Marker(
  //   markerId: MarkerId('_kLakeMarker'),
  //   infoWindow: InfoWindow(title: 'The Lake'),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position: LatLng(37.43296265331129, -122.08832357078792),
  // );
  // final Marker _kGooglePlexMarker = Marker(
  //   markerId: const MarkerId('_kGooglePlexMarker'),
  //   infoWindow: const InfoWindow(title: 'google plex'),
  //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  //   position: const LatLng(37.42796133580664, -122.085749655962),
  // );

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final TextEditingController _kDestinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MapProvider provider =
        MapProvider.get(context);
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              cameraTargetBounds: provider.cameraBounds,
              polylines: provider.polyLines,
              markers: provider.markers,
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                provider.mapController.complete(controller);
              },
              onTap: (point) {
                FocusScope.of(context).unfocus();
              },
            ),
            MySearchField(
              width: width,
              kDestinationController: _kDestinationController,
              provider: provider,
            ),
          ],
        ),
        floatingActionButton: DirectionLocationServices(provider: provider, width: width),
      ),
    );
  }
}

