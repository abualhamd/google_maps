import 'package:flutter/material.dart';
import 'package:google_maps/app/config/theme.dart';
import 'package:google_maps/app/utils/app_strings.dart';
import 'package:google_maps/app/utils/routes_manager.dart';
import 'package:google_maps/view/map_view/no_internet_connection_screen.dart';
import 'package:provider/provider.dart';
import '../view/map_view/provider/map_provider.dart';
import '../view/map_view/map_screen.dart';
import 'package:google_maps/injection_container.dart' as di;

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
        // home: Builder(builder: (context) {
        //   return MapScreen();
        // }),
      ),
    );
  }
}
