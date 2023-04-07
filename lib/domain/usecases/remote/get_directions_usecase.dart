import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps/app/core/errors/failures.dart';
import 'package:google_maps/app/core/usecase/usecase.dart';
import 'package:google_maps/domain/entities/directions_entity.dart';

import '../../repo/repo.dart';

class DirectionsUseCase
    implements BaseUseCase<DirectionsEntity, DirectionsParams> {
  final Repo _repo;

  DirectionsUseCase({required Repo repo}) : _repo = repo;

  @override
  Future<Either<Failure, DirectionsEntity>> call(
      {required DirectionsParams params}) async {
    return await _repo.getDirections(
        origin: params.origin, destination: params.destination);
  }
}

class DirectionsParams extends Equatable {
  final String origin;
  final String destination;

  const DirectionsParams({required this.origin, required this.destination});
  @override
  List<Object?> get props => [origin, destination];
}
