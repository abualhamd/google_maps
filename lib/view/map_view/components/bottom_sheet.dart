import 'package:flutter/material.dart';
import 'package:google_maps/app/core/utils/values_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/core/utils/app_strings.dart';
import 'map_type_widget.dart';

class CustomButtomSheet extends StatelessWidget {
  const CustomButtomSheet({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            // TODO
            // vertical: width * ValuesManager.s0_05,
            horizontal: width * ValuesManager.s0_02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: width * ValuesManager.s0_04,
                horizontal: ValuesManager.s0_065),
            child: const Text(AppStrings.mapType),
          ),
          const MapTypesRowWidget(
          )
        ]),
      ),
    );
  }
}

class MapTypesRowWidget extends StatelessWidget {
  const MapTypesRowWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        MapTypeWidget(
          mapType: MapType.normal,
        ),
        MapTypeWidget(
          mapType: MapType.satellite,
        ),
        MapTypeWidget(
          mapType: MapType.terrain,
        ),
      ],
    );
  }
}
