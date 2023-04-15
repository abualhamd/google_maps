import 'package:google_maps/app/core/enums/enums.dart';
import 'package:google_maps/app/core/errors/exceptions.dart';
import 'package:google_maps/app/core/errors/failures.dart';

import 'package:dartz/dartz.dart';
import 'package:google_maps/app/core/extensions/position_extension.dart';
import 'package:google_maps/data/data%20sources/local_data_source.dart';
import 'package:google_maps/data/data%20sources/remote_data_source.dart';
import 'package:google_maps/data/mapper/mappers.dart';
import 'package:google_maps/domain/entities/directions_entity.dart';
import 'package:google_maps/domain/entities/suggested_location_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/repo/repo.dart';

class RepoImpl implements Repo {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;

  RepoImpl(
      {required LocalDataSource localDataSource,
      required RemoteDataSource remoteDataSource})
      : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, LatLng>> getCurrentPosition() async {
    try {
      // TODO handle permission denied exception
      final position = await _localDataSource.getCurrentPosition();
      return Right(position.getLatLng);
    } on GetCurrentPositionException {
      return Left(GetCurrentPositionFailure());
    }
  }

  @override
  Future<Either<Failure, LatLng>> getInputLocation(
      {required String location}) async {
    try {
      return Right(
          await _remoteDataSource.getInputLocation(location: location));
    } on GetCurrentPositionException {
      return Left(GetCurrentPositionFailure());
    }
  }

  @override
  Future<Either<Failure, DirectionsEntity>> getDirections(
      {required String origin,
      required String destination,
      required TransportationMode transportationMode}) async {
    try {
      final model = await _remoteDataSource.getDirections(
          origin: origin,
          destination: destination,
          transportationMode: transportationMode);
      return Right(model.toDomain());
    } on GetDirectionsException {
      return Left(GetDirectionsFailure());
    }
  }

  @override
  Future<Either<Failure, List<SuggestedLocationEntity>>> getSuggestedLocations(
      {required String query}) async {
    try {
      final results =
          await _remoteDataSource.getSuggestedLocation(query: query);
      return Right(results.map((e) => e.toDomain()).toList());
    } on GetSuggestedLocationsException {//TODO
      return Left(GetSuggestedLocationsFailure());
    }
  }
}
