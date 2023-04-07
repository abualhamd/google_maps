import 'package:google_maps/app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:google_maps/app/core/usecase/usecase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../repo/repo.dart';

class CurrentLocationUseCase implements BaseUseCase<LatLng, NoParams> {
  final Repo _repo;

  CurrentLocationUseCase({required Repo repo}) : _repo = repo;

  @override
  Future<Either<Failure, LatLng>> call({required NoParams params}) async {
    return await _repo.getCurrentPosition();
  }
}
