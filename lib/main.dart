// import packages
import 'package:flutter/material.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/providers/version_provider.dart';
import 'package:inghub_pomo/services/file_service.dart';
import 'package:inghub_pomo/services/log_service.dart';
import 'package:inghub_pomo/services/preference_service.dart';
import 'package:inghub_pomo/services/sqlite_service.dart';
import 'package:inghub_pomo/services/version_service.dart';
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
  await FileService().getLocalPath;
  await LogService().init();
  await SqliteService().database;
  await VersionService().init();
  await PreferenceService().initPrefs();

  await LogService().log("App started");

  // run app
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PreferenceProvider()),
      ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ChangeNotifierProvider(create: (_) => VersionProvider()),
      ChangeNotifierProvider(create: (_) => FileProvider()),
    ],
    child: const RootLayout(),
  ));
}
