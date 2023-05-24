import 'package:flutter/material.dart';
import 'package:google_maps/app/core/extensions/material_state_property_extension.dart';

import '../../../app/core/utils/colors_manager.dart';
import '../../../app/core/utils/routes_manager.dart';
import '../../../app/core/utils/values_manager.dart';
import '../../provider/map_provider.dart';

class DirectionLocationServices extends StatelessWidget {
  const DirectionLocationServices({
    Key? key,
    required this.provider,
    required this.width,
  }) : super(key: key);

  final MapProvider provider;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //? current location
        GestureDetector(
          onTap: () async {
            await provider.gotoCurrentLocation();
          },
          child: CircleAvatar(
            radius: width * ValuesManager.s0_065,
            backgroundColor: ColorsManager.white,
            child: const Icon(
              Icons.location_searching_outlined,
              color: ColorsManager.red,
            ),
          ),
        ),
        SizedBox(
          height: width * ValuesManager.s0_05,
        ),
        //? directions
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(Routes.directionsRoute),
          child: Material(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(width * ValuesManager.s0_025)),
            child: Container(
              height: 2 * width * ValuesManager.s0_063,
              width: 2 * width * ValuesManager.s0_065,
              decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius:
                      BorderRadius.circular(width * ValuesManager.s0_025)),
              child: const Icon(
                Icons.directions_outlined,
                color: ColorsManager.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: width * ValuesManager.s0_05,
        ),
      ],
    );
  }
}
