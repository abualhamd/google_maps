import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuggestedLocationEntity {
  String name;
  String description; //TODO create a mapper for this
  LatLng latLng;

  SuggestedLocationEntity(
      {required this.name, required this.description, required this.latLng}); //

  // factory SuggestedLocationEntity.fromJson({required Map<String, dynamic> json}){
  //   return SuggestedLocationEntity(name: json['main_text'], description: json['secondary_text']);//, location: location)
  // }
}
