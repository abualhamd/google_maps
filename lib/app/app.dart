import 'package:flutter/material.dart';
import 'package:google_maps/app/config/theme.dart';
import 'package:google_maps/app/core/utils/app_strings.dart';
import 'package:google_maps/app/core/utils/routes_manager.dart';
import 'package:google_maps/view/map_view/no_internet_connection_screen.dart';
import 'package:provider/provider.dart';
import '../view/provider/map_provider.dart';
import 'package:google_maps/injection_container.dart' as di;

import 'core/utils/colors_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          di.sl<MapProvider>(), //..getPropperScreen();
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.mapRoutes,
        onGenerateRoute: ((settings) => RoutesGenerator.getRoute(settings)),
        theme: AppThemes.lightTheme,
        title: AppStrings.appTitle,
        //todo check internet before showing map screen
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              Visibility(
                visible: MapProvider.get(context).showLoading,
                child: const Scaffold(
                  backgroundColor: ColorsManager.transparent,
                  body: Center(child: CircularProgressIndicator(color: ColorsManager.blue,)),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
