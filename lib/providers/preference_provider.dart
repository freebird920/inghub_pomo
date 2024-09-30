import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/services/preference_service.dart';
import 'package:flutter/material.dart';

class PreferenceProvider with ChangeNotifier {
  final PreferenceService _preferenceService = PreferenceService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PreferenceProvider();

  // 초기화 및 Preference 데이터 로드
  Future<void> init() async {
    _isLoading = true;
    await _preferenceService.initPrefs();
    _isLoading = false;
    notifyListeners(); // UI 갱신
  }

  bool? getPrefBool(String key) {
    return _preferenceService.getPrefBool(key);
  }

  int? getPrefInt(String key) {
    return _preferenceService.getPrefInt(key);
  }

  String? getPrefString(String key) {
    return _preferenceService.getPrefString(key);
  }

  Future<Result<bool>> setPrefBool(
      {required String key, required bool value}) async {
    try {
      final result =
          await _preferenceService.setPrefBool(key: key, value: value);
      if (!result.isSuccess) {
        throw Exception("setPrefString: result is not success");
      }
      return Result(data: result.successData);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      notifyListeners(); // UI 갱신
    }
  }

  Future<Result<bool>> setPrefString(
      {required String key, required String value}) async {
    try {
      final result =
          await _preferenceService.setPrefString(key: key, value: value);
      if (!result.isSuccess) {
        throw Exception("setPrefString: result is not success");
      }
      return Result(data: result.successData);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      notifyListeners(); // UI 갱신
    }
  }

  Future<Result<bool>> setPrefInt(
      {required String key, required int value}) async {
    try {
      final result =
          await _preferenceService.setPrefInt(key: key, value: value);
      if (!result.isSuccess) {
        throw Exception("setPrefString: result is not success");
      }
      return Result(data: result.successData);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      notifyListeners(); // UI 갱신
    }
  }
}
