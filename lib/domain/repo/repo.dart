import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/domain/entities/directions_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/core/errors/failures.dart';

abstract class Repo {
  Future<Either<Failure, LatLng>> getCurrentPosition();
  Future<Either<Failure, LatLng>> getInputLocation({required String location});
  Future<Either<Failure, DirectionsEntity>> getDirections({required String origin, required String destination});
}
