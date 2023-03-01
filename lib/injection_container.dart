import 'package:get_it/get_it.dart';
import 'package:google_maps/app/networking/network_info.dart';
import 'package:google_maps/view/map_view/provider/map_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // providers
  sl.registerLazySingleton<MapProvider>(() => MapProvider(networkInfo: sl()));

  // usecases

  // repos

  // datasources

  // core/app
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  // external
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
