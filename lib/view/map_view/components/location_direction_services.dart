import 'package:flutter/material.dart';
import 'package:google_maps/app/extensions/position_extension.dart';
import 'package:google_maps/app/extensions/material_state_property_extension.dart';

import '../../../app/utils/colors_manager.dart';
import '../../../app/utils/routes_manager.dart';
import '../../../app/utils/values_manager.dart';
import '../provider/map_provider.dart';

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
        GestureDetector(
          onTap: () async {
            final position = await provider.getCurrentPosition();
            await provider.goToPlace(latLng: position.getLatLng);
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
        SizedBox(
          // TODO
          height: 2 * width * ValuesManager.s0_063,
          width: 2 * width * ValuesManager.s0_065,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: ColorsManager.blue.getMaterialStateProperty,
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(width * ValuesManager.s0_025),
                ),
              ),
            ),
            // TODO
            child: const Icon(
              Icons.directions_outlined,
              color: ColorsManager.white,
            ),
            onPressed: () async {
              Navigator.of(context).pushNamed(Routes.directionsRoutes);
            },
          ),
        ),
        SizedBox(
          height: width * ValuesManager.s0_05,
        ),
      ],
    );
  }
}
