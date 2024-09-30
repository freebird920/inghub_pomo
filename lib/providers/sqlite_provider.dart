import 'package:flutter/foundation.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:inghub_pomo/services/sqlite_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteProvider with ChangeNotifier {
  Database? _database;

  List<ProfileSchema>? _profiles;
  List<ProfileSchema>? get profiles => _profiles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final SqliteService _sqliteService = SqliteService();

  SqliteProvider() {
    // 생성자에서는 초기화를 시작하지 않습니다.
  }

  Future<void> init() async {
    if (_database != null) return;

    _isLoading = true;

    try {
      await _sqliteService.initDB();
      _database = await _sqliteService.database;
      // 초기 데이터 로드
      await getProfiles();
    } catch (e) {
      // 에러 처리
      print("Database initialization error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertProfile(ProfileSchema profile) async {
    if (_database == null) return;

    final data = profile.toMap;

    await _database!.insert(
      "profiles",
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getProfiles(); // 데이터 변경 후 프로필 목록 업데이트
  }

  Future<List<ProfileSchema>> getProfiles() async {
    if (_database == null) return [];

    final List<Map<String, dynamic>> maps = await _database!.query("profiles");
    final result = maps.map((map) => ProfileSchema.fromMap(map)).toList();
    _profiles = result;
    notifyListeners();
    return result;
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    if (_database == null) return [];

    return await _database!.query(table);
  }

  Future<void> closeDb() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      notifyListeners();
    }
  }
}
