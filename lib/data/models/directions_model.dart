import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsModel {
  String encodedPolyLinePoints;
  LatLng destinationCoorinates;
  CameraPostionCornerPoints cornerPoints;

  DirectionsModel(
      {required this.encodedPolyLinePoints,
      required this.destinationCoorinates,
      required this.cornerPoints});

  factory DirectionsModel.fromJson(Map<String, dynamic> json) {
    //? ecnodedPolyLinePoints
    final String polyLine = json['routes'][0]['overview_polyline']['points'];
    //? destinationCoordinates
    final double lat = json['routes'][0]['legs'][0]['end_location']['lat'];
    final double lng = json['routes'][0]['legs'][0]['end_location']['lng'];

    return DirectionsModel(
        encodedPolyLinePoints: polyLine,
        destinationCoorinates: LatLng(lat, lng),
        cornerPoints:
            CameraPostionCornerPoints.fromJson(json['routes'][0]['bounds']));
  }
}

class CameraPostionCornerPoints {
  LatLng northEastPoint;
  LatLng southWestPoint;

  CameraPostionCornerPoints(
      {required this.northEastPoint, required this.southWestPoint});

  factory CameraPostionCornerPoints.fromJson(Map<String, dynamic> json) {
    LatLng northEastPoint =
        LatLng(json['northeast']['lat'], json['northeast']['lng']);
    LatLng southWestPoint =
        LatLng(json['southwest']['lat'], json['southwest']['lng']);

    return CameraPostionCornerPoints(
        northEastPoint: northEastPoint, southWestPoint: southWestPoint);
  }
}
