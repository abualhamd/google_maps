import 'package:flutter/material.dart';

import '../../view/directions_view/directions_view.dart';
import '../../view/map_view/map_screen.dart';
import 'app_strings.dart';

abstract class Routes {
  static const String mapRoutes = '/';
  static const String directionsRoutes = '/directionsRoute';
}

abstract class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mapRoutes:
        return MaterialPageRoute(builder: ((_) => MapScreen()));
      case Routes.directionsRoutes:
        return MaterialPageRoute(builder: ((_) => DirectinsScreen()));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.undefinedRoute)),
        body: const Center(child: Text(AppStrings.undefinedRoute)),
      ),
    );
  }
}
