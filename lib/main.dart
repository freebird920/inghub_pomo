// import packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// project providers
import 'package:inghub_pomo/providers/file_provider.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';

// root layout
import 'package:inghub_pomo/app/layout.dart';

// main function
void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PreferenceProvider()),
      ChangeNotifierProvider(create: (_) => FileProvider()),
    ],
    child: const RootLayout(),
  ));
}
