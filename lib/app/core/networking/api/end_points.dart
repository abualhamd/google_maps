abstract class EndPoints {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';
  static const String placeId = '$_baseUrl/place/findplacefromtext/json';
  static const String placeDetails = '$_baseUrl/place/details/json';
  static const String directions = '$_baseUrl/directions/json';
  static const String geoCode = '$_baseUrl/geocode/json';
  static const String queryautocomplete =
      '$_baseUrl/place/queryautocomplete/json';
}
