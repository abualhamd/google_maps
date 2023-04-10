import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps/app/core/errors/failures.dart';
import 'package:google_maps/app/core/usecase/usecase.dart';
import 'package:google_maps/domain/entities/directions_entity.dart';

import '../../../app/core/enums/enums.dart';
import '../../repo/repo.dart';

class DirectionsUseCase
    implements BaseUseCase<DirectionsEntity, DirectionsParams> {
  final Repo _repo;

  DirectionsUseCase({required Repo repo}) : _repo = repo;

  @override
  Future<Either<Failure, DirectionsEntity>> call(
      {required DirectionsParams params}) async {
    return await _repo.getDirections(
        origin: params.origin, destination: params.destination, transportationMode: params._trasnportationMode);
  }
}

class DirectionsParams extends Equatable {
  final String _origin;
  final String _destination;
  final TransportationMode _trasnportationMode;

  const DirectionsParams(
      {required String origin,
      required String destination,
      required TransportationMode trasnportationMode})
      : _origin = origin,
        _destination = destination,
        _trasnportationMode = trasnportationMode;
  @override
  List<Object?> get props => [_origin, _destination, _trasnportationMode];

  get origin => _origin;
  get destination => _destination;
  get trasnportationMode => _trasnportationMode;
}
