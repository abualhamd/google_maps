import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps/app/core/enums/enums.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../app/core/networking/api/end_points.dart';

import 'package:http/http.dart' as http;

import '../../domain/entities/suggested_location_entity.dart';
import '../models/directions_model.dart';
import '../models/suggested_location_model.dart';

abstract class RemoteDataSource {
  Future<LatLng> getInputLocation({required String location});
  Future<DirectionsModel> getDirections(
      {required String origin,
      required String destination,
      required TransportationMode transportationMode});
  Future<List<SuggestedLocationModel>> getSuggestedLocation(
      {required String query});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final _apiKey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

  @override
  Future<DirectionsModel> getDirections(
      {required String origin,
      required String destination,
      required TransportationMode transportationMode}) async {
    final originID = await _getPlaceId(origin);
    final destinationID = await _getPlaceId(destination);
    final String mode;
    switch (transportationMode) {
      case TransportationMode.bicycling:
        mode = 'bicycling';
        break;
      case TransportationMode.walking:
        mode = 'walking';
        break;
      case TransportationMode.transit:
        mode = 'transit';
        break;
      default:
        mode = 'driving';
    }

    final Uri uri = Uri.parse(EndPoints.directions).replace(queryParameters: {
      'key': _apiKey,
      'origin': 'place_id:$originID',
      'destination': 'place_id:$destinationID',
      'mode': mode
    });

    http.Response res = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(res.body);
    return DirectionsModel.fromJson(json);
  }

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

  Future<Map<String, dynamic>> _getPlaceDetails(
      {required String placeId}) async {
    Uri uri = Uri.parse(
      EndPoints.placeDetails,
    ).replace(queryParameters: {
      'key': _apiKey,
      'place_id': placeId,
    });
    http.Response response = await http.get(uri);
    return jsonDecode(response.body);
  }

  Future<LatLng> _getLatLngFromPlaceId({required String placeId}) async {
    Map<String, dynamic> json = await _getPlaceDetails(placeId: placeId);
    Map<String, dynamic> result = json['result'];

    final double lat = result['geometry']['location']['lat'];
    final double lng = result['geometry']['location']['lng'];
    return LatLng(lat, lng);
  }

  @override
  Future<LatLng> getInputLocation({required String location}) async {
    String placeId = await _getPlaceId(location);

    return await _getLatLngFromPlaceId(placeId: placeId);
  }

  @override
  Future<List<SuggestedLocationModel>> getSuggestedLocation(
      {required String query}) async {
    Uri uri = Uri.parse(
      EndPoints.queryautocomplete,
    ).replace(queryParameters: {
      'key': _apiKey,
      'input': query,
    });

    http.Response response = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);

    final List<SuggestedLocationModel> predictions = [];
    for (final e in json['predictions']) {
      final String? placeId = e['place_id'];
      
      if(placeId != null){
        final latLng =
          await _getLatLngFromPlaceId(placeId: placeId);
      final String mainText = e['structured_formatting']['main_text'];
      final String? secondaryText = e['structured_formatting']['secondary_text'];
      predictions.add(
          SuggestedLocationModel(name: mainText, description: secondaryText, location: latLng));
      }
    }

    return predictions;
  }
}
