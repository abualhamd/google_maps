import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsEntity {
  List<LatLng> polyPoints;
  LatLng destinationCoorinates;
  LatLng camerTargetLatLng;

  DirectionsEntity(
      {required this.polyPoints,
      required this.destinationCoorinates,
      required this.camerTargetLatLng});
}
