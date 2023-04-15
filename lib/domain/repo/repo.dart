import 'package:dartz/dartz.dart';
import 'package:google_maps/app/core/enums/enums.dart';
import 'package:google_maps/domain/entities/directions_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/core/errors/failures.dart';
import '../entities/suggested_location_entity.dart';

abstract class Repo {
  Future<Either<Failure, LatLng>> getCurrentPosition();
  Future<Either<Failure, LatLng>> getInputLocation({required String location});
  Future<Either<Failure, DirectionsEntity>> getDirections(
      {required String origin,
      required String destination,
      required TransportationMode transportationMode});
  Future<Either<Failure, List<SuggestedLocationEntity>>> getSuggestedLocations({required String query});
}
