import 'dart:math';
import 'package:inghub_pomo/classes/user_class.dart';
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

  Future<Database> get database async {
    if (_sqliteDatabase != null) {
      return _sqliteDatabase!;
    }
    _sqliteDatabase = await initDB();
    return _sqliteDatabase!;
  }

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
  }

  Future<User> insertUSer(User user) async {
    final db = await database;
    db.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  Future<List<User>> batchInsert() async {
    final db = await database;
    final batch = db.batch();
    final Random random = Random();
    final List<User> userList = List.generate(
      1000,
      (index) => User(
        id: index + 1,
        name: 'User $index',
        email: 'user$index@example.com',
        password: random.nextInt(9999),
        phoneNumber: random.nextInt(10000),
      ),
    );
    for (final User user in userList) {
      batch.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
    return userList;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (index) {
      return User(
        id: maps[index]['id'],
        name: maps[index]['name'],
        email: maps[index]['email'],
        password: maps[index]['password'],
        phoneNumber: maps[index]['phoneNumber'],
      );
    });
  }

  Future<User?> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        phoneNumber: maps[0]['phoneNumber'],
      );
    }

    return null;
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    final Batch batch = db.batch();

    batch.delete('users');

    await batch.commit();
  }
}
