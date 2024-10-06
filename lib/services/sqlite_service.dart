import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/schema/pomo_preset_schema.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:inghub_pomo/services/file_service.dart';
import 'package:inghub_pomo/services/log_service.dart';
import 'package:inghub_pomo/services/preference_service.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteService {
  SqliteService._internal();
  static final SqliteService _instance = SqliteService._internal();
  factory SqliteService() => _instance;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Database? _sqliteDatabase;
  Database? get sqliteDatabase => _sqliteDatabase;

  // Future<Database> get database async {
  //   if (_sqliteDatabase != null) {
  //     return _sqliteDatabase!;
  //   }
  //   _sqliteDatabase = await initDB();
  //   return _sqliteDatabase!;
  // }

  Future<Database> initDB() async {
    try {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      FileService fileService = FileService();
      final localPathResult = await fileService.getLocalPath;
      if (localPathResult.error != null) {
        throw Exception(localPathResult.error);
      }
      final dbPath = join(localPathResult.successData, "data.db");
      final database = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        ),
      );
      LogService().log("Database initialized");
      _sqliteDatabase = database;
      _isInitialized = true;
      return database;
    } catch (e) {
      LogService().log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<Result<ProfileSchema>> getProfile(String uuid) async {
    try {
      final result = await _sqliteDatabase!.query(
        "profiles",
        where: "uuid = ?",
        whereArgs: [uuid],
      );
      if (result.isNotEmpty) {
        return Result(data: ProfileSchema.fromMap(result.first));
      } else {
        return Result(error: Exception("Profile not found"));
      }
    } catch (e) {
      return Result(error: Exception(e.toString()));
    }
  }

  /// # _onCreate
  /// - 데이터베이스 생성 시 호출되는 메서드
  /// - 데이터베이스에 테이블을 생성하고 초기 데이터를 삽입한다.
  /// - [database]: 데이터베이스 인스턴스
  /// - [version]: 데이터베이스 버전
  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    LogService().log("Creating tables");
    await db
        .execute(ProfileSchema.schema.generateCreateTableSQL()); // 프로필 테이블 생성
    await db.execute(
        PomoTypeSchema.schema.generateCreateTableSQL()); // 포모 타입 테이블 생성
    await db.execute(
        PomoPresetSchema.schema.generateCreateTableSQL()); // 포모 프리셋 테이블 생성

    // 초기 pomoType 데이터 삽입
    final List<PomoTypeSchema> defaultPomoTypes =
        PomoTypeSchema.defaultPomoTypes;

    final PomoPresetSchema defaultPomoPreset = PomoPresetSchema(
      uuid: "default",
      pomoTypes: [
        defaultPomoTypes[0],
        defaultPomoTypes[1],
        defaultPomoTypes[0],
        defaultPomoTypes[1],
        defaultPomoTypes[0],
        defaultPomoTypes[1],
        defaultPomoTypes[0],
        defaultPomoTypes[2],
      ],
    );

    final defaultProfile = ProfileSchema.generateDefault(
      pomoPreset: defaultPomoPreset,
    );

    for (final item in defaultPomoTypes) {
      try {
        await db.insert(
          "pomoTypes",
          item.toMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        LogService().log(e.toString());
      }
    }

    // 초기 프로필 데이터 삽입

    try {
      final pomoPresetResult = await db.insert(
        "pomoPresets",
        defaultPomoPreset.toMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final defaultProfileResult = await db.insert(
        "profiles",
        defaultProfile.toMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (defaultProfileResult >= 0 || pomoPresetResult >= 0) {
        LogService().log("Default profile inserted");
        PreferenceService().setPrefString(
          key: "current_profile_uuid",
          value: defaultProfile.uuid,
        );
      }
    } catch (e) {
      LogService().log(e.toString());
    }
  }
}
