import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../model/theme_model.dart';

class ThemeRepository {
  static const String themeKey = 'app_theme';
  static const String isSystemThemeKey = 'is_system_theme';
  static const String customColorKey = 'custom_theme_color';

  // Save theme type to shared preferences
  Future<void> saveTheme(ThemeType themeType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, themeType.index);

    // When explicitly setting a theme, turn off system theme following
    if (themeType != ThemeType.system) {
      await saveUseSystemTheme(false);
    }
  }

  // Save custom theme color
  Future<void> saveCustomTheme(Color primaryColor) async {
    final prefs = await SharedPreferences.getInstance();

    // Save the color value as an integer
    await prefs.setInt(customColorKey, primaryColor.value);

    // Also save that we're using a custom theme type
    await saveTheme(ThemeType.custom);
  }

  // Add a method to save system theme preference
  Future<void> saveUseSystemTheme(bool useSystem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isSystemThemeKey, useSystem);
  }

  // Check if system theme is being used
  Future<bool> isUsingSystemTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isSystemThemeKey) ?? false;
  }

  // Get custom theme color (if any)
  Future<Color?> getCustomThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(customColorKey);

    if (colorValue != null) {
      return Color(colorValue);
    }

    return null;
  }

  // Modify your getTheme method
  Future<ThemeType> getTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if system theme is being used
    final useSystemTheme = prefs.getBool(isSystemThemeKey) ?? false;
    if (useSystemTheme) {
      return ThemeType.system;
    }

    // Otherwise return saved theme
    final themeIndex = prefs.getInt(themeKey);
    if (themeIndex != null && ThemeType.values.length > themeIndex) {
      return ThemeType.values[themeIndex];
    }

    return ThemeType.light;
  }
}
