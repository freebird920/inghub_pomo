import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/services/preference_service.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider();

  final PreferenceService _preferenceService = PreferenceService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _currentProfileUuid;
  String? get currentProfileUuid => _currentProfileUuid;

  // 초기화 및 Preference 데이터 로드
  Future<void> init() async {
    _isLoading = true;

    // PreferenceService 초기화 확인
    if (!_preferenceService.isInitialized) {
      await _preferenceService.initPrefs();
    }

    // Theme 데이터 로드

    // profile 데이터 로드
    _currentProfileUuid = getCurrentProfileUuid; // currentProfileUuid

    // UI 갱신
    notifyListeners(); // UI 갱신
  }

  String? get getCurrentProfileUuid {
    return _preferenceService.getPrefString("current_profile_uuid");
  }

  Future<Result<String>> setCurrentProfileUuid(String targetUuid) async {
    try {
      final result = await _preferenceService.setPrefString(
        key: "current_profile_uuid",
        value: targetUuid,
      );
      if (result.isSuccess) {
        _currentProfileUuid = targetUuid;
      }
      notifyListeners();
      return Result(data: targetUuid);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<bool>> removeCurrentProfileUuid() async {
    try {
      final result =
          await _preferenceService.removePref("current_profile_uuid");
      if (result.isSuccess) {
        _currentProfileUuid = null;
      }
      notifyListeners();
      return Result(data: true);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
