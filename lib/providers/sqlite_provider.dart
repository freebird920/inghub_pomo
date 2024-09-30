import 'package:flutter/foundation.dart';
import 'package:inghub_pomo/services/sqlite_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteProvider with ChangeNotifier {
  Database? _database;
  SqliteProvider._internal() {
    sqfliteFfiInit();
  }
  static final SqliteProvider _instance = SqliteProvider._internal();
  factory SqliteProvider() => _instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final SqliteService _sqliteService = SqliteService();

  Future<void> init() async {
    _isLoading = true;
    await _sqliteService.initDB();
    _database = await _sqliteService.database;
    _isLoading = false;
    notifyListeners();
  }
}
