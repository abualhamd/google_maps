import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps/app/core/errors/failures.dart';
import 'package:google_maps/app/core/usecase/usecase.dart';

import '../../entities/suggested_location_entity.dart';
import '../../repo/repo.dart';

class SuggestedLocationUseCase
    implements
        BaseUseCase<List<SuggestedLocationEntity>, SuggestedLocationParams> {
  final Repo _repo;
  SuggestedLocationUseCase({required Repo repo}) : _repo = repo;
  @override
  Future<Either<Failure, List<SuggestedLocationEntity>>> call(
      {required SuggestedLocationParams params}) async {
    return await _repo.getSuggestedLocations(query: params.query);
  }
}

class SuggestedLocationParams extends Equatable {
  final String query;

  const SuggestedLocationParams({required this.query});

  @override
  List<Object?> get props => [query];
}
