import 'package:get_it/get_it.dart';
import 'package:google_maps/app/core/networking/network_info.dart';
import 'package:google_maps/data/data%20sources/local_data_source.dart';
import 'package:google_maps/data/data%20sources/remote_data_source.dart';
import 'package:google_maps/data/repo/repo_impl.dart';
import 'package:google_maps/domain/usecases/local/get_current_location_usecase.dart';
import 'package:google_maps/domain/usecases/remote/get_Input_loaction_usecase.dart';
import 'package:google_maps/domain/usecases/remote/get_directions_usecase.dart';
import 'package:google_maps/view/provider/map_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'domain/repo/repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // providers
  sl.registerLazySingleton<MapProvider>(() => MapProvider(
      networkInfo: sl(),
      directionsUseCase: sl(),
      inputLocationUseCase: sl(),
      currentLocationUseCase: sl()));

  // usecases
  sl.registerLazySingleton<DirectionsUseCase>(
      () => DirectionsUseCase(repo: sl()));
  sl.registerLazySingleton<InputLocationUseCase>(
      () => InputLocationUseCase(repo: sl()));
  sl.registerLazySingleton<CurrentLocationUseCase>(
      () => CurrentLocationUseCase(repo: sl()));

  // repos
  sl.registerLazySingleton<Repo>(
      () => RepoImpl(localDataSource: sl(), remoteDataSource: sl()));
  // datasources
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());
  // core/app
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  // external
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
