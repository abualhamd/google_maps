import 'package:flutter/material.dart';
import 'package:google_maps/app/core/extensions/media_query_extension.dart';
import 'package:google_maps/app/core/utils/values_manager.dart';
import 'package:google_maps/view/provider/map_provider.dart';
import 'package:provider/provider.dart';

import '../../app/core/utils/colors_manager.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = MapProvider.get(context);
    final width = context.width;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(width * ValuesManager.s0_3),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * ValuesManager.s0_05,
                    vertical: width * ValuesManager.s0_03),
                    // TODO hero animation
                child: TextField(
                    cursorColor: ColorsManager.blue,
                    controller: provider.destinationController,
                    onChanged: (value) async {
                      await context
                          .read<MapProvider>()
                          .getSuggestedLocations(query: value);
                    },
                    onSubmitted: ((location) async {
                      if (location.isNotEmpty) {
                        await provider.gotoInputLocation(location: location);
                        Navigator.pop(context);
                      }
                    }),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: ColorsManager.grey,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: ColorsManager.grey,
                        ),
                        onPressed: () {
                          // TODO pick up from here
                          provider.clearSuggestedLocations();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: ValuesManager.s2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderSide: BorderSide(width: ValuesManager.s2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    
                    ),
                  ),
              ),
            ),
          ),
        ),
        body: ListView.separated(
          itemCount: provider.suggestedLocations.length,
          itemBuilder: ((context, index) {
            final suggestedLocation = provider.suggestedLocations[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  await provider.navigateToLocation(
                      latLng: suggestedLocation.latLng);
                  Navigator.pop(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(suggestedLocation.name),
                    Text(
                      suggestedLocation.description,
                      style: TextStyle(color: ColorsManager.grey),
                    ),
                  ],
                ),
              ),
            );
          }),
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              color: ColorsManager.grey,
              height: 1,
              width: double.infinity,
            );
          },
        ),
      ),
    );
  }
}
