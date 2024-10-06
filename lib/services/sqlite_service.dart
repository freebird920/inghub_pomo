import 'package:inghub_pomo/classes/user_class.dart';
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
      return database;
    } catch (e) {
      LogService().log(e.toString());
      throw Exception(e.toString());
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

    // 초기 pomoType 데이터 삽입
    final defaultPomoTypes = PomoTypeSchema.defaultPomoTypes;
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
    final defaultProfile = ProfileSchema.generateDefault();
    try {
      final defaultProfileResult = await db.insert(
        "profiles",
        defaultProfile.toMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (defaultProfileResult >= 0) {
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

  Future<User> insertUSer(User user) async {
    // final db = await database;
    final db = _sqliteDatabase;
    if (db == null) {
      throw Exception("Database is not initialized");
    }
    db.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }
}
