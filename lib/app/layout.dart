import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inghub_pomo/app/routes.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
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
        final Color themeColor = Color(
            preferenceProvider.getPrefInt("theme_color") ??
                Colors.indigo.value);
        final ColorScheme colorScheme = ColorScheme.fromSeed(
          seedColor: themeColor,
          brightness: darkTheme ? Brightness.dark : Brightness.light,
        );

        return Builder(
          builder: (context) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: scaffoldMessengerKey,
              theme: ThemeData(
                fontFamily: "NotoSansKR",
                colorScheme: colorScheme,
                appBarTheme: AppBarTheme(
                  surfaceTintColor: colorScheme.primary.withOpacity(0.9),
                  elevation: 4.0,
                  // systemOverlayStyle: SystemUiOverlayStyle.dark,
                  shadowColor:
                      colorScheme.primary.withOpacity(0.2), // 흐릿한 그림자 색상

                  // backgroundColor: colorScheme.onPrimary,
                  titleTextStyle: TextStyle(
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              routerConfig: ingHubRouter,
            );
          },
        );
      },
    );
  }
}
