import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuggestedLocationModel {
  String name;
  String? description;//TODO create a mapper for this
  LatLng location;

  SuggestedLocationModel(
      {required this.name, required this.description, required this.location});//, required this.location
  
  // factory SuggestedLocationModel.fromJson({required Map<String, dynamic> json}){
  //   return SuggestedLocationModel(name: json['main_text'], description: json['secondary_text'], location: json['location']);//, 
  // }
}
