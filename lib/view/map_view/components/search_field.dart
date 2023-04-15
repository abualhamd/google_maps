import 'package:flutter/material.dart';
import 'package:google_maps/app/core/utils/colors_manager.dart';
import '../../../app/core/utils/routes_manager.dart';
import '../../../app/core/utils/values_manager.dart';
import '../../provider/map_provider.dart';

class MySearchField extends StatelessWidget {
  const MySearchField({
    Key? key,
    required this.width,
    required this.provider,
  }) : super(key: key);

  final double width;
  final MapProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * ValuesManager.s0_03,
        vertical: width * ValuesManager.s0_05,
      ),
      child: TextField(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.searchRoute);
        },
        keyboardType: TextInputType.none,
        cursorColor: ColorsManager.blue,
        controller: provider.destinationController,
        // onSubmitted: ((location) async {
        //   // TODO
        //   if (location.isNotEmpty) {
        //     await provider.gotoInputLocation(location: location);
        //   }
        // }),
      ),
    );
  }
}
