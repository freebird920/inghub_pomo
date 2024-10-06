// import packages
import 'package:flutter/material.dart';
import 'package:inghub_pomo/providers/profile_provider.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/providers/theme_provider.dart';
import 'package:inghub_pomo/providers/version_provider.dart';
import 'package:inghub_pomo/services/file_service.dart';
import 'package:inghub_pomo/services/log_service.dart';
import 'package:provider/provider.dart';

// project providers

// root layout
import 'package:inghub_pomo/app/layout.dart';

// main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init services

  // 모든 서비스 비동기 초기화
  await Future.wait([
    FileService().getLocalPath,
    LogService().init(),
    // SqliteService().database,
    // PreferenceService().initPrefs(),
  ]);

  // 프로바이더 선언 및 초기화
  await LogService().log("App started");

  final SqliteProvider databaseProvider = SqliteProvider();
  final ProfileProvider profileProvider = ProfileProvider();
  final ThemeProvider themeProvider = ThemeProvider();
  final VersionProvider versionProvider = VersionProvider();

  // db provider init
  await databaseProvider.init();

  // 나머지 provider init
  await Future.wait(
    [
      versionProvider.init(),
      themeProvider.init(),
      profileProvider.init(),
    ],
  );
  // run app
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => profileProvider),
      ChangeNotifierProvider(create: (_) => databaseProvider),
      ChangeNotifierProvider(create: (_) => versionProvider),
      ChangeNotifierProvider(create: (_) => themeProvider),
    ],
    child: const RootLayout(),
  ));
}
