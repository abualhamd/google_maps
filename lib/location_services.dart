import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class LocationServices {
  static const String _apiKey = 'AIzaSyDht9UCuhEWb3zKd7_RojVVqguOyXDlOrs';

  static Future<String> _getPlaceId(String place) async {
    String placesUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$place&inputtype=textquery&key=$_apiKey';
    http.Response response = await http.get(Uri.parse(placesUrl));
    Map<String, dynamic> json = jsonDecode(response.body);

    return json['candidates'][0]['place_id'];
  }

  static Future<Map<String, dynamic>> getPlace(String place) async {
    String placeId = await _getPlaceId(place);
    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details?place_id=$placeId&key=$_apiKey';
    var response = await http.get(Uri.parse(placeDetailsUrl));
    Map<String, dynamic> json = jsonDecode(response.body);
    Map<String, dynamic> results = json['result'];

    return results;
  }
}
