import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _kAppTheme = 'Theme';

  static Future<String> getAppTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_kAppTheme) ?? null;
  }

  static Future<bool> setAppTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kAppTheme, value);
  }
}
