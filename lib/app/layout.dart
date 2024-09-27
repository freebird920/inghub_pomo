import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/routes.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';
import 'package:provider/provider.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, preferenceProvider, _) {
        final bool darkTheme =
            preferenceProvider.getPrefBool("theme_dark_mode") ?? false;
        return MaterialApp.router(
          theme: ThemeData(
            fontFamily: "NotoSansKR",
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.purple,
              brightness: darkTheme ? Brightness.dark : Brightness.light,
            ),
          ),
          routerConfig: ingHubRouter,
        );
      },
    );
  }
}
