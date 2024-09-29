import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/services/version_service.dart';
import 'package:pub_semver/pub_semver.dart';

class VersionProvider with ChangeNotifier {
  VersionProvider() {
    _init();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Version? _currentVersion;
  Version? get currentVersion => _currentVersion;
  Version? _latestVersion;
  Version? get latestVersion => _latestVersion;

  final VersionService _versionService = VersionService();

  void _init() async {
    _isLoading = true;
    await _getLatestVersion();
    await _getCurrentVersion();
    _isLoading = false;
    notifyListeners();
  }

  Future<Version> _getCurrentVersion() async {
    if (_currentVersion != null) {
      return _currentVersion!;
    }
    Version currentVersion = await _versionService.getCurrentVersion();
    _currentVersion = currentVersion;
    return currentVersion;
  }

  Future<Result<Version>> _getLatestVersion() async {
    if (_latestVersion != null) {
      return Result(data: _latestVersion);
    }
    final latestVersion = await _versionService.getLatestVersion();
    if (latestVersion.isSuccess && latestVersion.data != null) {
      _latestVersion = latestVersion.data;
    }
    return latestVersion;
  }
}
