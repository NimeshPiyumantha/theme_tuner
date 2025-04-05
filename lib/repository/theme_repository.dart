import 'package:shared_preferences/shared_preferences.dart';

import '../model/theme_model.dart';

class ThemeRepository {
  static const String themeKey = 'app_theme';

  // Save theme type to shared preferences
  Future<void> saveTheme(ThemeType themeType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, themeType.index);
  }

  // Load saved theme type from shared preferences
  Future<ThemeType> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeKey);

    if (themeIndex != null && ThemeType.values.length > themeIndex) {
      return ThemeType.values[themeIndex];
    }

    return ThemeType.light; // Default theme if none saved
  }
}
