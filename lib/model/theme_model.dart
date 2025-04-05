import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

// Define the different theme options
enum ThemeType { light, dark, custom, system }

class ThemeModel extends Equatable {
  final ThemeType type;
  final ThemeData themeData;

  const ThemeModel({required this.type, required this.themeData});

  @override
  List<Object> get props => [type];
}

class AppThemes {
  // Add this to your AppThemes class
  static ThemeModel systemTheme() {
    return ThemeModel(
      type: ThemeType.system,
      themeData: ThemeData.light(), // Default, will be overridden
    );
  }

  // Light theme
  static final ThemeModel light = ThemeModel(
    type: ThemeType.light,
    themeData: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
    ),
  );

  // Dark theme
  static final ThemeModel dark = ThemeModel(
    type: ThemeType.dark,
    themeData: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.indigo,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
    ),
  );

  // Method to get ThemeModel from ThemeType
  static ThemeModel getThemeFromType(ThemeType type) {
    switch (type) {
      case ThemeType.dark:
        return dark;
      case ThemeType.light:
      default:
        return light;
    }
  }

  // Method to generate a custom theme from any color
  static ThemeModel generateCustomTheme(Color primaryColor, {String? name}) {
    // Create a MaterialColor swatch from the primary color
    final MaterialColor swatch = createMaterialColor(primaryColor);

    final brightness = estimateBrightness(primaryColor);
    final contrastColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return ThemeModel(
      type: ThemeType.custom,
      themeData: ThemeData(
        brightness: brightness,
        primarySwatch: swatch,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: contrastColor,
        ),
        scaffoldBackgroundColor: brightness == Brightness.dark
            ? Color.lerp(Colors.black, primaryColor, 0.1)
            : Color.lerp(Colors.white, primaryColor, 0.05),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: swatch,
          brightness: brightness,
        ),
        // Add more customizations here
      ),
    );
  }

  // Helper method to create a MaterialColor from any Color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // Helper to estimate brightness from a color
  static Brightness estimateBrightness(Color color) {
    final double luminance = color.computeLuminance();
    return luminance > 0.5 ? Brightness.light : Brightness.dark;
  }
}
