import 'package:equatable/equatable.dart';
import 'package:google_maps/app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:google_maps/app/core/usecase/usecase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../repo/repo.dart';

class InputLocationUseCase
    implements BaseUseCase<LatLng, GetInputLocationParams> {
  final Repo _repo;

  InputLocationUseCase({required Repo repo}) : _repo = repo;

  @override
  Future<Either<Failure, LatLng>> call(
      {required GetInputLocationParams params}) async {
    return await _repo.getInputLocation(location: params.location);
  }
}

class GetInputLocationParams extends Equatable {
  final String location;
  const GetInputLocationParams({required this.location});
  @override
  List<Object?> get props => [location];
}
