import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps/app/core/errors/failures.dart';

abstract class BaseUseCase<RetType, Params> {
  Future<Either<Failure, RetType>> call({required Params params});
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}