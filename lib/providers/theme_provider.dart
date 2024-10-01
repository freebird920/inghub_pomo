import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/services/preference_service.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider();

  final PreferenceService _preferenceService = PreferenceService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Color _themeColor = Colors.indigo;
  Color get themeColor => _themeColor;

  // 초기화 및 Preference 데이터 로드
  Future<void> init() async {
    _isLoading = true;

    // PreferenceService 초기화 확인
    if (!_preferenceService.isInitialized) {
      await _preferenceService.initPrefs();
    }

    // Theme 데이터 로드
    _isDarkMode = isDarkModePref ?? false;
    _themeColor = getThemeColor ?? Colors.indigo;
    _isLoading = false;

    // UI 갱신
    notifyListeners(); // UI 갱신
  }

  bool? get isDarkModePref {
    return _preferenceService.getPrefBool("theme_dark_mode") ?? false;
  }

  Future<Result<bool>> setDarkModePref(bool targetMode) async {
    final result = await _preferenceService.setPrefBool(
        key: "theme_dark_mode", value: targetMode);
    if (result.isSuccess) {
      _isDarkMode = targetMode;
    }
    notifyListeners();
    return result;
  }

  Color? get getThemeColor {
    final int? colorValue = _preferenceService.getPrefInt("theme_color");
    colorValue is int ? Color(colorValue) : null;
    return null;
  }

  Future<Result<bool>> setThemeColor(Color targetColor) async {
    final result = await _preferenceService.setPrefInt(
        key: "theme_color", value: targetColor.value);
    if (result.isSuccess) {
      _themeColor = targetColor;
    }
    notifyListeners();
    return result;
  }
}
