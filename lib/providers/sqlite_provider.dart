import 'package:flutter/foundation.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:inghub_pomo/services/log_service.dart';
import 'package:inghub_pomo/services/sqlite_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider with ChangeNotifier {
  List<ProfileSchema>? _profiles;
  List<ProfileSchema>? get profiles => _profiles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final SqliteService _sqliteService = SqliteService();
  late Database _database;

  DatabaseProvider();

  Future<void> init() async {
    _isLoading = true;
    try {
      if (_sqliteService.sqliteDatabase != null) {
        _database = _sqliteService.sqliteDatabase!;
      } else {
        await _sqliteService.initDB();
        _database = _sqliteService.sqliteDatabase!;
      }
      // 초기 데이터 로드
      await getProfiles();
    } catch (e) {
      // 에러 처리
      final exception = Exception("Database initialization error: $e");
      LogService().log("Database initialization error: $e");
      throw exception;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertProfile(ProfileSchema profile) async {
    final data = profile.toMap;
    await _database.insert(
      "profiles",
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getProfiles(); // 데이터 변경 후 프로필 목록 업데이트
  }

  Future<List<ProfileSchema>> getProfiles() async {
    final List<Map<String, dynamic>> maps = await _database.query("profiles");
    final result = maps.map((map) => ProfileSchema.fromMap(map)).toList();
    _profiles = result;
    notifyListeners();
    return result;
  }

  Future<void> removeProfile(String uuid) async {
    await _database.delete(
      "profiles",
      where: "uuid = ?",
      whereArgs: [uuid],
    );

    await getProfiles(); // 데이터 변경 후 프로필 목록 업데이트
  }

  Future<void> updateProfile(ProfileSchema profile) async {
    final data = profile.toMap;
    await _database.update(
      "profiles",
      data,
      where: "uuid = ?",
      whereArgs: [profile.uuid],
    );

    await getProfiles(); // 데이터 변경 후 프로필 목록 업데이트
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    return await _database.query(table);
  }

  Future<void> closeDb() async {
    await _database.close();
    notifyListeners();
  }
}
