// import packages
import 'package:flutter/material.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/providers/version_provider.dart';
import 'package:inghub_pomo/services/file_service.dart';
import 'package:inghub_pomo/services/log_service.dart';
import 'package:provider/provider.dart';

// project providers
import 'package:inghub_pomo/providers/file_provider.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';

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
  final DatabaseProvider databaseProvider = DatabaseProvider();
  final PreferenceProvider preferenceProvider = PreferenceProvider();
  final VersionProvider versionProvider = VersionProvider();
  await Future.wait(
    [
      databaseProvider.init(),
      preferenceProvider.init(),
      versionProvider.init(),
    ],
  );
  // run app
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => preferenceProvider),
      ChangeNotifierProvider(create: (_) => databaseProvider),
      ChangeNotifierProvider(create: (_) => VersionProvider()),
      ChangeNotifierProvider(create: (_) => FileProvider()),
    ],
    child: const RootLayout(),
  ));
}
