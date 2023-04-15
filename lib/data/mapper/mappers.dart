import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps/data/models/directions_model.dart';
import 'package:google_maps/domain/entities/directions_entity.dart';
import 'package:google_maps/domain/entities/suggested_location_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/suggested_location_model.dart';

extension DirectionsModelToEntity on DirectionsModel {
  DirectionsEntity toDomain() {
    List<LatLng> points = [];

    for (final point
        in PolylinePoints().decodePolyline(encodedPolyLinePoints)) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    final double targetLat = (cornerPoints.northEastPoint.latitude +
            cornerPoints.southWestPoint.latitude) /
        2;
    final double targetLng = (cornerPoints.northEastPoint.longitude +
            cornerPoints.southWestPoint.longitude) /
        2;

    return DirectionsEntity(
      polyPoints: points,
      destinationCoorinates: destinationCoorinates,
      camerTargetLatLng: LatLng(targetLat, targetLng),
    );
  }
}

extension SuggestedModelToEntity on SuggestedLocationModel {
  SuggestedLocationEntity toDomain() {
    return SuggestedLocationEntity(
        name: name, description: description ?? '', latLng: location);
  }
}
