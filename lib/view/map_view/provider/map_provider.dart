import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app/api_keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../app/networking/api/end_points.dart';
import '../../../app/networking/network_info.dart';
import 'package:http/http.dart' as http;

class MapProvider with ChangeNotifier {
  static MapProvider get(BuildContext context) =>
      Provider.of<MapProvider>(context);
  // Enter your google maps api key
  final _apiKey = ApiKeys.googleApiKey;

  final Completer<GoogleMapController> mapController = Completer();
  final NetworkInfo _networkInfo;
  Set<Polyline> polyLines = {};
  Set<Marker> markers = {};
  CameraTargetBounds cameraBounds = CameraTargetBounds.unbounded;
  // late Widget propperScreen; // = NoInternetConnectionScreen();

  MapProvider({required NetworkInfo networkInfo}) : _networkInfo = networkInfo;

  // void getPropperScreen() async {
  //   bool value = await _networkInfo.isConnected;
  //   propperScreen = (value) ? MyMap() : const NoInternetConnectionScreen();

  //   notifyListeners();
  // }

  Future<String> _getPlaceId(String place) async {
    Uri uri = Uri.parse(EndPoints.placeId).replace(queryParameters: {
      'input': place,
      'inputtype': 'textquery',
      'key': _apiKey,
    });
    http.Response response = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);

    return json['candidates'][0]['place_id'];
  }

  Future<LatLng> getPlace(String place) async {
    String placeId = await _getPlaceId(place);

    Uri uri = Uri.parse(
      EndPoints.placeDetails,
    ).replace(queryParameters: {
      'key': _apiKey,
      'place_id': placeId,
    });
    http.Response response = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);
    Map<String, dynamic> result = json['result'];

    // return results;
    final double lat = result['geometry']['location']['lat'];
    final double lng = result['geometry']['location']['lng'];
    return LatLng(lat, lng);
  }

  Future<void> goToPlace({required LatLng latLng}) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    // final LatLng latLng = LatLng(lat, lng);

    markers.clear();
    markers.add(Marker(markerId: const MarkerId('markerId'), position: latLng));
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14)));

    notifyListeners();
  }

  Future<Position> getCurrentPosition() async {
    // TODO fix this
    await Geolocator.requestPermission()
        .then((value) => null)
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print('Error: $error');
    });
    return await Geolocator.getCurrentPosition();
  }

  Future getPolyLine(
      {required String origin, required String destination}) async {
    List<LatLng> points = [];

    final originID = await _getPlaceId(origin);
    final destinationID = await _getPlaceId(destination);
    final Uri uri = Uri.parse(EndPoints.directions).replace(queryParameters: {
      'key': _apiKey,
      'origin': 'place_id:$originID',
      'destination': 'place_id:$destinationID',
      'mode': 'walking'
    });
    http.Response res = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(res.body);
    final polyLine = json['routes'][0]['overview_polyline']['points'];
    for (final point in PolylinePoints().decodePolyline(polyLine)) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    polyLines.clear();
    polyLines.add(Polyline(
      color: Colors.deepPurple,
      polylineId: PolylineId('temp'),
      points: points,
    ));
    // adding a marker to the destination
    final double lat = json['routes'][0]['legs'][0]['end_location']['lat'];
    final double lng = json['routes'][0]['legs'][0]['end_location']['lng'];

    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId('destination'), position: LatLng(lat, lng)));
    final GoogleMapController controller = await mapController.future;

    notifyListeners();

    Map<String, dynamic> northEast = json['routes'][0]['bounds']['northeast'];
    LatLng northEastPoint = LatLng(northEast['lat'], northEast['lng']);
    Map<String, dynamic> southwest = json['routes'][0]['bounds']['southwest'];
    LatLng southWestPoint = LatLng(southwest['lat'], southwest['lng']);

    // cameraBounds = CameraTargetBounds(
    //     LatLngBounds(northeast: northEastPoint, southwest: southWestPoint));

    final double targetLat =
        (northEastPoint.latitude + southWestPoint.latitude) / 2;
    final double targetLng =
        (northEastPoint.longitude + southWestPoint.longitude) / 2;
    // final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(targetLat, targetLng),
          zoom: 8, //TODO calculate the zoom
        ),
      ),
    );
    // todo make sure you're measuring the shortest distance
    print((northEastPoint.latitude - southWestPoint.latitude) * 450);
    print((northEastPoint.longitude - southWestPoint.longitude) * 450);
    // cameraBounds = CameraTargetBounds.unbounded;
    // notifyListeners();
  }

  // Future getGeoCode() async {
  //   Uri uri = Uri.parse(EndPoints.geoCode)
  //       .replace(queryParameters: {'latlng': '40,-110'});

  //   http.Response response = await http.get(uri);
  //   Map<String, dynamic> json = jsonDecode(response.body);
  //   String placeID = json['results'][0]['place_id'];
  // }
}
