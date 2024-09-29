import 'dart:convert';

import 'package:http/http.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class VersionService {
  VersionService._privateConstructor();
  static final VersionService _instance = VersionService._privateConstructor();
  factory VersionService() {
    return _instance;
  }

  Version? _currentVersion;
  Version? get currentVersion => _currentVersion;

  Version? _latestVersion;
  Version? get latestVersion => _latestVersion;

  bool _isInit = false;
  bool get isInit => _isInit;

  Future<void> init() async {
    await getCurrentVersion();
    await getLatestVersion();
    _isInit = true;
  }

  Future<Version> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageinfoVersion = packageInfo.version;
    Version version = Version.parse(packageinfoVersion);
    _currentVersion = version;
    return version;
  }

  Future<Result<Version>> getLatestVersion() async {
    final url = Uri.parse(
        'https://api.github.com/repos/freebird920/inghub_pomo/releases/latest');
    try {
      final response = await get(url);

      if (response.statusCode == 200) {
        // JSON 파싱
        final Map<String, dynamic> data = jsonDecode(response.body);

        // 최신 버전 정보 가져오기 (예: 'tag_name'이 버전 정보일 경우)
        final latestVersion = data['tag_name'];
        _latestVersion = Version.parse(latestVersion);
        return Result(data: Version.parse(latestVersion));
      } else {
        throw Exception('Failed to load version');
      }
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
