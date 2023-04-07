import 'package:geolocator/geolocator.dart';

abstract class LocalDataSource {
  Future<Position> getCurrentPosition();
}

class LocalDataSourceImpl implements LocalDataSource{
  
  @override
  Future<Position> getCurrentPosition() async {
    // TODO fix this
    await Geolocator.requestPermission()
        .then((value) => null)
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print('Error: $error');
    });
    return await Geolocator.getCurrentPosition();
  }

}
