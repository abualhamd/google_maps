import 'package:flutter/material.dart';
import 'package:google_maps/app/utils/app_strings.dart';
import 'package:google_maps/app/utils/colors_manager.dart';
import 'package:google_maps/app/utils/values_manager.dart';
import 'package:google_maps/view/map_view/provider/map_provider.dart';

import 'components/location_input_field.dart';

class DirectinsScreen extends StatelessWidget {
  DirectinsScreen({super.key});

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    MapProvider provider = MapProvider.get(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide(
                  color: ColorsManager.grey, width: ValuesManager.s0_5),
            ),
            elevation: ValuesManager.s0_006,
            onPressed: () async {
              if (_originController.text.isNotEmpty &&
                  _destinationController.text.isNotEmpty) {
                await provider.getPolyLine(
                    origin: _originController.text,
                    destination: _destinationController.text);
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.search_outlined,
              color: ColorsManager.grey,
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(width * ValuesManager.s0_45),
            child: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * ValuesManager.s0_05,
                    vertical: width * ValuesManager.s0_03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //? origin
                    MyLocationInputField(
                      controller: _originController,
                      hintText: AppStrings.enterOrigin,
                    ),
                    SizedBox(
                      height: width * ValuesManager.s0_02,
                    ),
                    //? distination
                    MyLocationInputField(
                      controller: _destinationController,
                      hintText: AppStrings.enterDestination,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
