import 'package:inghub_pomo/classes/result_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  PreferenceService._privateConstructor();

  static final PreferenceService _instance =
      PreferenceService._privateConstructor();

  factory PreferenceService() {
    return _instance;
  }

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  bool get isInitialized => _prefs != null;

  Future<void> initPrefs() async {
    if (_prefs != null) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Result<bool>> setPrefBool(
      {required String key, required bool value}) async {
    try {
      if (_prefs == null) {
        await initPrefs();
      }

      final result = await _prefs?.setBool(key, value);
      return Result(data: result ?? false);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<bool>> setPrefString(
      {required String key, required String value}) async {
    try {
      if (_prefs == null) {
        await initPrefs();
      }
      final result = await _prefs?.setString(key, value);
      return Result(data: result ?? false);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<bool>> setPrefInt(
      {required String key, required int value}) async {
    try {
      if (_prefs == null) {
        await initPrefs();
      }
      final result = await _prefs?.setInt(key, value);
      return Result(data: result ?? false);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  String? getPrefString(String key) {
    if (_prefs == null) {
      return null;
    }
    return _prefs?.getString(key);
  }

  bool? getPrefBool(String key) {
    if (_prefs == null) {
      return null;
    }
    return _prefs?.getBool(key);
  }

  int? getPrefInt(String key) {
    if (_prefs == null) {
      return null;
    }
    return _prefs?.getInt(key);
  }

  Future<Result<bool>> removePref(String key) async {
    try {
      if (_prefs == null) {
        await initPrefs();
      }
      final result = await _prefs?.remove(key);
      return Result(data: result ?? false);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
