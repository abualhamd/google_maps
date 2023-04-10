import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps/domain/usecases/local/get_current_location_usecase.dart';
import 'package:google_maps/domain/usecases/remote/input_loaction_usecase.dart';
import 'package:google_maps/domain/usecases/remote/directions_usecase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/core/enums/enums.dart';
import '../../app/core/networking/network_info.dart';

import '../../app/core/usecase/usecase.dart';

class MapProvider with ChangeNotifier {
  static MapProvider get(BuildContext context) =>
      Provider.of<MapProvider>(context);

  bool showLoading = false;
  final Completer<GoogleMapController> mapController = Completer();
  final NetworkInfo _networkInfo;
  Set<Polyline> polyLines = {};
  Set<Marker> markers = {};
  CameraTargetBounds cameraBounds = CameraTargetBounds.unbounded;
  // late Widget propperScreen; // = NoInternetConnectionScreen();
  final CurrentLocationUseCase _currentLocationUseCase;
  final InputLocationUseCase _inputLocationUseCase;
  final DirectionsUseCase _directionsUseCase;

  MapProvider(
      {required NetworkInfo networkInfo,
      required CurrentLocationUseCase currentLocationUseCase,
      required InputLocationUseCase inputLocationUseCase,
      required DirectionsUseCase directionsUseCase})
      : _networkInfo = networkInfo,
        _currentLocationUseCase = currentLocationUseCase,
        _inputLocationUseCase = inputLocationUseCase,
        _directionsUseCase = directionsUseCase;

  void _setShowLoading(bool cond) {
    showLoading = cond;
    notifyListeners();
  }

  Future<void> _goToPlace({required LatLng latLng}) async {
    _setShowLoading(true);

    markers.clear();
    markers.add(Marker(markerId: const MarkerId('markerId'), position: latLng));
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14)));
    _setShowLoading(false);
  }

  Future<void> gotoCurrentLocation() async {
    final response = await _currentLocationUseCase.call(params: NoParams());
    response.fold((failure) {
      // TODO handle failure
    }, (currentLocationLatLng) async {
      await _goToPlace(latLng: currentLocationLatLng);
    });
  }

  Future<void> gotoInputLocation({required String location}) async {
    final response = await _inputLocationUseCase.call(
        params: GetInputLocationParams(location: location));
    response.fold((failure) {
      // TODO handle failure
    }, (inputLocationLatLng) async {
      await _goToPlace(latLng: inputLocationLatLng);
    });
  }

  Future getPolyLine(
      {required String origin, required String destination, required, required TransportationMode transportationMode}) async {
    _setShowLoading(true);

    final result = await _directionsUseCase.call(
        params: DirectionsParams(origin: origin, destination: destination, trasnportationMode: transportationMode));
    result.fold((failure) {
      // TODO handle failure
    }, (directionsEntity) async {
      //? polyline
      polyLines.clear();
      polyLines.add(Polyline(
        color: Colors.deepPurple,
        polylineId: const PolylineId('temp'),
        points: directionsEntity.polyPoints,
      ));
      //? destination marker
      markers.clear();
      markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: directionsEntity.destinationCoorinates));
      final GoogleMapController controller = await mapController.future;

      //?camera position
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: directionsEntity.camerTargetLatLng,
            zoom: 8, //TODO calculate the zoom
          ),
        ),
      );
    });
    _setShowLoading(false);

    // cameraBounds = CameraTargetBounds(
    //     LatLngBounds(northeast: northEastPoint, southwest: southWestPoint));
    // todo make sure you're measuring the shortest distance
    // print((northEastPoint.latitude - southWestPoint.latitude) * 450);
    // print((northEastPoint.longitude - southWestPoint.longitude) * 450);
    // cameraBounds = CameraTargetBounds.unbounded;
    // notifyListeners();
  }

  // Future getGeoCode() async {
  //   Uri uri = Uri.parse(EndPoints.geoCode)
  //       .replace(queryParameters: {'latlng': '40,-110'});
  //   http.Response response = await http.get(uri);
  //   Map<String, dynamic> json = jsonDecode(response.body);
  //   String placeID = json['results'][0]['place_id'];
  // }
}
