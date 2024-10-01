import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/routes.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final bool darkTheme = themeProvider.isDarkMode;
        final Color themeColor = themeProvider.themeColor;
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
                  centerTitle: true,
                  shadowColor:
                      colorScheme.shadow.withOpacity(0.5), // 흐릿한 그림자 색상
                  titleTextStyle: TextStyle(
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: colorScheme.primary,
                  ),

                  // surfaceTintColor: colorScheme.primary.withOpacity(0.9),
                  // elevation: 4.0,
                  // systemOverlayStyle: SystemUiOverlayStyle.dark,
                  // backgroundColor: colorScheme.onPrimary,
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
