import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/utils/values_manager.dart';
import '../provider/map_provider.dart';

class MySearchField extends StatelessWidget {
  const MySearchField({
    Key? key,
    required this.width,
    required TextEditingController kDestinationController,
    required this.provider,
  })  : _kDestinationController = kDestinationController,
        super(key: key);

  final double width;
  final TextEditingController _kDestinationController;
  final MapProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * ValuesManager.s0_03,
          vertical: width * ValuesManager.s0_05),
      child: TextField(
        controller: _kDestinationController,
        onSubmitted: ((value) async {
          // TODO
          if (value.isNotEmpty) {
            LatLng latLng = await provider.getPlace(value);
            provider.goToPlace(latLng: latLng);
          }
        }),
      ),
    );
  }
}
