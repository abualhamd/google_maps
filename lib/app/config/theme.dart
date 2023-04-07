import 'package:flutter/material.dart';
import 'package:google_maps/app/core/extensions/material_color_extension.dart';
import 'package:google_maps/app/core/utils/colors_manager.dart';

abstract class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: ColorsManager.white.getMaterial,
    //? input decoration
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.white,
      //TODO change the 20 to be a value depending on the width of the screen
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
    ),
    //? icon decoration
    iconTheme: const IconThemeData(color: ColorsManager.white),
  );
}
