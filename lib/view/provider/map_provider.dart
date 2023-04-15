import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps/domain/usecases/local/get_current_location_usecase.dart';
import 'package:google_maps/domain/usecases/remote/input_loaction_usecase.dart';
import 'package:google_maps/domain/usecases/remote/directions_usecase.dart';
import 'package:google_maps/domain/usecases/remote/suggested_location_usecase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/core/enums/enums.dart';
import '../../app/core/networking/network_info.dart';

import '../../app/core/usecase/usecase.dart';
import '../../domain/entities/suggested_location_entity.dart';

class MapProvider with ChangeNotifier {
  static MapProvider get(BuildContext context) =>
      Provider.of<MapProvider>(context);

  bool showLoading = false;
  final Completer<GoogleMapController> mapController = Completer();
  final NetworkInfo _networkInfo;
  Set<Polyline> polyLines = {};
  Set<Marker> markers = {};
  MapType mapType = MapType.normal;
  CameraTargetBounds cameraBounds = CameraTargetBounds.unbounded;
  final TextEditingController destinationController = TextEditingController();
  List<SuggestedLocationEntity> _suggestedLocations = [];
  final CurrentLocationUseCase _currentLocationUseCase;
  final InputLocationUseCase _inputLocationUseCase;
  final DirectionsUseCase _directionsUseCase;
  final SuggestedLocationUseCase _suggestedLocationUseCase;

  MapProvider({
    required NetworkInfo networkInfo,
    required CurrentLocationUseCase currentLocationUseCase,
    required InputLocationUseCase inputLocationUseCase,
    required DirectionsUseCase directionsUseCase,
    required SuggestedLocationUseCase suggestedLocationUseCase,
  })  : _networkInfo = networkInfo,
        _currentLocationUseCase = currentLocationUseCase,
        _inputLocationUseCase = inputLocationUseCase,
        _directionsUseCase = directionsUseCase,
        _suggestedLocationUseCase = suggestedLocationUseCase;

  List<SuggestedLocationEntity> get suggestedLocations => _suggestedLocations;
  void clearSuggestedLocations() {
    destinationController.clear();
    _suggestedLocations = [];
    notifyListeners();
  }

  void setMapType(MapType type) {
    mapType = type;
    notifyListeners();
  }

  void _setShowLoading(bool cond) {
    showLoading = cond;
    notifyListeners();
  }

  Future<void> navigateToLocation({required LatLng latLng}) async {
    _setShowLoading(true);

    polyLines.clear();
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
      await navigateToLocation(latLng: currentLocationLatLng);
    });
  }

  Future<void> gotoInputLocation({required String location}) async {
    final response = await _inputLocationUseCase.call(
        params: GetInputLocationParams(location: location));
    response.fold((failure) {
      // TODO handle failure
    }, (inputLocationLatLng) async {
      await navigateToLocation(latLng: inputLocationLatLng);
    });
  }

  Future<void> getPolyLine(
      {required String origin,
      required String destination,
      required,
      required TransportationMode transportationMode}) async {
    _setShowLoading(true);

    final result = await _directionsUseCase.call(
        params: DirectionsParams(
            origin: origin,
            destination: destination,
            trasnportationMode: transportationMode));
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

  Future<void> getSuggestedLocations({required String query}) async {
    final result = await _suggestedLocationUseCase.call(
        params: SuggestedLocationParams(query: query));

    result.fold((failure) {
      // TODO handle failure
    }, (suggestedLocationsList) {
      _suggestedLocations = suggestedLocationsList;
      notifyListeners();
    });
  }
  // Future getGeoCode() async {
  //   Uri uri = Uri.parse(EndPoints.geoCode)
  //       .replace(queryParameters: {'latlng': '40,-110'});
  //   http.Response response = await http.get(uri);
  //   Map<String, dynamic> json = jsonDecode(response.body);
  //   String placeID = json['results'][0]['place_id'];
  // }
}
