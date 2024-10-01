import 'package:inghub_pomo/classes/user_class.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:inghub_pomo/services/file_service.dart';
import 'package:inghub_pomo/services/log_service.dart';
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

  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute(ProfileSchema.schema.generateCreateTableSQL());
    await db.execute(PomoTypeSchema.schema.generateCreateTableSQL());
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
