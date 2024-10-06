import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:inghub_pomo/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:inghub_pomo/services/sqlite_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider();

  final PreferenceService _preferenceService = PreferenceService();
  final SqliteService _sqliteServifce = SqliteService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _currentProfileUuid;
  String? get currentProfileUuid => _currentProfileUuid;

  ProfileSchema? _currentProfile;
  ProfileSchema? get currentProfile => _currentProfile;

  // 초기화 및 Preference 데이터 로드
  Future<void> init() async {
    _isLoading = true;
    await _preferenceService.initPrefs();
    if (_sqliteServifce.isInitialized) {
      await _sqliteServifce.initDB();
    }

    // profile 데이터 로드
    _currentProfileUuid = getCurrentProfileUuid; // currentProfileUuid
    if (_currentProfileUuid != null) {
      final result = await getProfile(_currentProfileUuid!);
      if (!result.isSuccess || result.isError || result.isNull) {
        _errorMessage = "ERROR Profile not found";
      } else {
        _currentProfile = result.successData;
      }
    }
    // UI 갱신
    notifyListeners(); // UI 갱신
  }

  Future<Result<ProfileSchema>> getProfile(String uuid) async {
    try {
      final result = await _sqliteServifce.getProfile(uuid);
      if (result.error != null) {
        return Result(error: result.error);
      }
      if (!result.isSuccess) {
        throw Exception("Profile not found");
      }
      // _currentProfile = result.successData;
      return Result(data: result.successData);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
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
