import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/layout.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => PreferenceProvider(),
      )
    ],
    child: const RootLayout(),
  ));
}
