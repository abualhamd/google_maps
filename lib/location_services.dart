import 'dart:async';
import 'dart:convert';
import 'package:google_maps/app/networking/api/end_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

abstract class LocationServices {
  static const String _apiKey = 'AIzaSyDht9UCuhEWb3zKd7_RojVVqguOyXDlOrs';
  static const String _mapboxKey =
      'sk.eyJ1IjoiYWJ1YWxoYW1kIiwiYSI6ImNsZDNnYWo1ZDBpNjAzb3BydXl0cDY5MGgifQ.2A4HFYeKe2ESInnjMBnjeA';

  static Future<String> _getPlaceId(String place) async {
    Uri uri = Uri.parse(EndPoints.placeId).replace(queryParameters: {
      'input': place,
      'inputtype': 'textquery',
      'key': _apiKey,
    });
    http.Response response = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);

    return json['candidates'][0]['place_id'];
  }

  static Future<Map<String, dynamic>> getPlace(String place) async {
    String placeId = await _getPlaceId(place);

    Uri uri = Uri.parse(
      EndPoints.placeDetails,
    ).replace(queryParameters: {
      'key': _apiKey,
      'place_id': placeId,
    });
    http.Response response =
        await http.get(uri); //headers: {'Accept': 'application/json'}
    Map<String, dynamic> json = jsonDecode(response.body);
    Map<String, dynamic> results = json['result'];

    return results;
  }

  static Future<void> goToPlace(
      {required Map<String, dynamic> place,
      required Set<Marker> markers,
      required Completer<GoogleMapController> completer}) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final LatLng latLng = LatLng(lat, lng);

    markers.clear();
    markers.add(Marker(markerId: const MarkerId('markerId'), position: latLng));
    final GoogleMapController controller = await completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 12)));
  }

  static Future<Polyline> getPolyLine() async {
    List<LatLng> latLngList = [];
    String url =
        'https://api.mapbox.com/directions/v5/mapbox/cycling/-122.085749655962,37.42796133580664;-122.08832357078792,37.43296265331129?access_token=$_mapboxKey&geometries=geojson&language=en&overview=full&alternatives=true&continue_straight=true';
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> json = jsonDecode(response.body);
    // print(json['routes'][0]['geometry']['coordinates']);
    List lngLatList = json['routes'][0]['geometry']['coordinates'];
    for (var element in lngLatList) {
      final latLng = LatLng(element[1], element[0]);
      latLngList.add(latLng);
    }
    // print(latLngList);
    return Polyline(
      polylineId: const PolylineId('_kPolyline'),
      width: 5,
      points: latLngList,
    );
  }
}
