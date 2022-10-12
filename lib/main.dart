import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final Marker _kLakeMarker = const Marker(
    markerId: MarkerId('_kLakeMarker'),
    infoWindow: InfoWindow(title: 'The Lake'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.43296265331129, -122.08832357078792),
  );
  final Marker _kGooglePlexMarker = Marker(
    markerId: const MarkerId('_kGooglePlexMarker'),
    infoWindow: const InfoWindow(title: 'google plex'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    position: const LatLng(37.42796133580664, -122.085749655962),
  );

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  List<LatLng> latLngVals = [];
  static const Polyline _kPolyline =
      Polyline(polylineId: PolylineId('_kPolyline'), width: 5, points: [
    LatLng(37.42796133580664, -122.085749655962),
    LatLng(37.43296265331129, -122.08832357078792)
  ]);

  // Polygon _kPolygon = Polygon(
  //     polygonId: PolygonId('_kPolygon'),
  //     fillColor: Colors.transparent,
  //     strokeWidth: 5,
  //     points: [
  // LatLng(37.42796133580664, -122.085749655962),
  // LatLng(37.43296265331129, -122.08832357078792),
  // LatLng(37.44296265331129, -122.08632357078792),
  // LatLng(37.42796133580664, -122.080749655962),
  // ]);

  Set<Marker> markers = {};
  Set<Polygon> _polygons = {};

  final TextEditingController _kDestinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Expanded(
            TextField(
              decoration: const InputDecoration(hintText: 'Destination'),
              controller: _kDestinationController,
              onChanged: (text) {
                print('text: $text');
                print(_kDestinationController.text);
              },
              onSubmitted: ((value) async {
                // await LocationServices.getPlaceId(_kDestinationController.text);
                Map<String, dynamic> placeDetails =
                    await LocationServices.getPlace(value);
                // print(placeDetails);
                _goToPlace(placeDetails);
              }),
            ),
            // ),
            Expanded(
              child: GoogleMap(
                // markers: {_kLakeMarker, _kGooglePlexMarker},
                // polylines: {_kPolyline},
                // polygons: {_kPolygon},
                polygons: _polygons,
                markers: markers,
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: (point) {
                  latLngVals.add(point);
                  setPolygon();
                  setState(() {});
                  print(_polygons);
                },
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: const Text('To the lake!'),
        //   icon: const Icon(Icons.directions_boat),
        // ),
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final LatLng latLng = LatLng(lat, lng);

    markers.clear();
    markers.add(Marker(markerId: MarkerId('markerId'), position: latLng));
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 12)));
  }

  int polygonCounter = 0;
  void setPolygon() {
    Polygon polygon = Polygon(
        polygonId: PolygonId('poly$polygonCounter'),
        points: latLngVals,
        strokeWidth: 2,
        fillColor: Colors.transparent);

    polygonCounter++;

    _polygons.clear();
    _polygons.add(polygon);
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
