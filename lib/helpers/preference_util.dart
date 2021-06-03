import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

class PreferenceUtils {
  static SharedPreferences _prefsInstance;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static Future<void> init() async {
    _prefsInstance = await _instance;
  }

  static Future<String> getString(String keyString) async {
    return (await _instance).getString(keyString);
  }

  static Future<void> setString(String keyString, String value) async {
    (await _instance).setString(keyString, value);
  }
}
