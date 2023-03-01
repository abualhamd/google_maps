import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension GetLatLng on Position {
  LatLng get getLatLng {
    return LatLng(latitude, longitude);
  }
}
