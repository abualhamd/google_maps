import 'package:flutter/material.dart';
import 'package:google_maps/app/core/utils/colors_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../app/core/utils/app_strings.dart';
import '../../../app/core/utils/assets_manager.dart';
import '../../../app/core/utils/values_manager.dart';
import '../../provider/map_provider.dart';
import '../../../app/core/extensions/media_query_extension.dart';

class MapTypeWidget extends StatelessWidget {
  const MapTypeWidget({
    super.key,
    required MapType mapType,
  }) : _mapType = mapType;

  final MapType _mapType;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MapProvider>(context, listen: false);
    final width = context.width;
    final String mapTypeLabel;
    final String mapTypeImage;

    switch (_mapType) {
      // case MapType.normal:
      //   mapTypeImage = ImagesManager.normalMaptype;
      //   mapTypeLabel = 'Default';
      //   break;
      case MapType.satellite:
        mapTypeImage = ImagesManager.satelliteMapType;
        mapTypeLabel = AppStrings.mapTypeSatellite;
        break;
      case MapType.terrain:
        mapTypeImage = ImagesManager.terrainlMaptype;
        mapTypeLabel = AppStrings.mapTypeTerrain;
        break;
      // case MapType.none:
      // case MapType.hybrid:
      default:
        mapTypeImage = ImagesManager.normalMaptype;
        mapTypeLabel = AppStrings.mapTypeNormal;
    }
    return InkWell(
      onTap: () {
        provider.setMapType(_mapType);
      },
      child: Column(
        children: [
          Container(
            height: width * ValuesManager.s0_18,
            width: width * ValuesManager.s0_25,
            decoration: BoxDecoration(
              border: (_mapType == Provider.of<MapProvider>(context).mapType)
                  ? Border.all(
                      width: ValuesManager.s2, color: ColorsManager.blue)
                  : null,
              borderRadius: BorderRadius.circular(width * ValuesManager.s0_05),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(mapTypeImage),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: width * ValuesManager.s0_04),
            child: Text(mapTypeLabel),
          ),
        ],
      ),
    );
  }
}
