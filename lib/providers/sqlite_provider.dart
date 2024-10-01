import 'package:flutter/foundation.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:inghub_pomo/services/log_service.dart';
import 'package:inghub_pomo/services/sqlite_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteProvider with ChangeNotifier {
  List<ProfileSchema>? _profiles;
  List<ProfileSchema>? get profiles => _profiles;
  List<PomoTypeSchema>? _pomoTypes;
  List<PomoTypeSchema>? get pomoTypes => _pomoTypes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final SqliteService _sqliteService = SqliteService();
  late Database _database;

  SqliteProvider();

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
      await Future.wait(
        [
          getProfiles(),
          getPomoTypes(),
        ],
      );
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

  // Profile 관리

  /// # insertProfile
  /// - [ProfileSchema]를 받아 profiles 테이블에 추가합니다.
  ///
  Future<Result<ProfileSchema>> insertProfile(ProfileSchema profile) async {
    final data = profile.toMap;
    try {
      await _database.insert(
        "profiles",
        data,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return Result(data: profile);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      await getProfiles(); // 데이터 변경 후 프로필 목록 업데이트
    }
  }

  /// # getProfiles
  /// - profiles 테이블의 모든 데이터를 가져옵니다.
  /// - 데이터를 가져온 후 _profiles에 저장하고 notifyListeners()를 호출합니다.
  /// - Ui를 업데이트 함.
  Future<List<ProfileSchema>> getProfiles() async {
    final List<Map<String, dynamic>> maps = await _database.query("profiles");
    final result = maps.map((map) => ProfileSchema.fromMap(map)).toList();
    _profiles = result;
    notifyListeners();
    return result;
  }

  /// # removeProfile
  /// - uuid를 받아 profiles 테이블에서 해당 데이터를 삭제합니다.
  /// - 데이터를 삭제한 후 프로필 목록을 업데이트합니다.
  Future<Result<String>> removeProfile(String uuid) async {
    try {
      await _database.delete(
        "profiles",
        where: "uuid = ?",
        whereArgs: [uuid],
      );
      await getProfiles(); // 데이터 변경 후 프로필 목록 업데이트
      return Result(data: uuid);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  /// # updateProfile
  /// - [ProfileSchema]를 받아 profiles 테이블에서 해당 데이터를 업데이트합니다.
  /// - 데이터를 업데이트한 후 프로필 목록을 업데이트합니다.
  Future<Result<ProfileSchema>> updateProfile(ProfileSchema profile) async {
    try {
      final data = profile.toMap;
      final int result = await _database.update(
        "profiles",
        data,
        where: "uuid = ?",
        whereArgs: [profile.uuid],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      if (result == 0) {
        throw Exception("No data found with uuid: ${profile.uuid}");
      }
      return Result(data: profile);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      await getProfiles(); // 데이터 변경 후 프로필 목록 업데이트
    }
  }

  // pomoTypeSchema

  /// # insertProfile
  /// - [PomoTypeSchema]를 받아 profiles 테이블에 추가합니다.
  ///
  Future<Result<PomoTypeSchema>> insertPomoType(PomoTypeSchema pomoType) async {
    final data = pomoType.toMap;
    try {
      await _database.insert(
        "pomoTypes",
        data,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return Result(data: pomoType);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      await getPomoTypes(); // 데이터 변경 후 프로필 목록 업데이트
    }
  }

  Future<List<PomoTypeSchema>> getPomoTypes() async {
    final List<Map<String, dynamic>> maps = await _database.query("pomoTypes");
    final result = maps.map((map) => PomoTypeSchema.fromMap(map)).toList();
    _pomoTypes = result;
    notifyListeners();
    return result;
  }

  Future<Result<String>> removePomoType(String uuid) async {
    try {
      await _database.delete(
        "pomoTypes",
        where: "uuid = ?",
        whereArgs: [uuid],
      );
      await getPomoTypes(); // 데이터 변경 후 프로필 목록 업데이트
      return Result(data: uuid);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<PomoTypeSchema>> updatePomoType(PomoTypeSchema pomoType) async {
    try {
      final data = pomoType.toMap;
      final int result = await _database.update(
        "pomoTypes",
        data,
        where: "uuid = ?",
        whereArgs: [pomoType.uuid],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      if (result == 0) {
        throw Exception("No data found with uuid: ${pomoType.uuid}");
      }
      return Result(data: pomoType);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      await getPomoTypes(); // 데이터 변경 후 프로필 목록 업데이트
    }
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    return await _database.query(table);
  }

  Future<void> closeDb() async {
    await _database.close();
    notifyListeners();
  }
}
