import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';
import 'package:inghub_pomo/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ListTileDarkMode extends StatelessWidget {
  const ListTileDarkMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // PreferenceProvider

    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // isDark
    final bool isDark = themeProvider.isDarkMode;

    return ListTile(
      leading:
          isDark ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
      title: const Text("ThemeMode"),
      subtitle: Text(
          "Current: ${isDark ? "Dark" : "Light"}  Target: ${isDark ? "Light" : "Dark"}"),
      onTap: () async {
        final Result<bool> result =
            await themeProvider.setDarkModePref(!isDark);
        // final Result<bool> result = await preferenceProvider.setPrefBool(
        //     key: "theme_dark_mode", value: !isDark);
        if (result.isError) {
          openCompSnackBar(
            message: result.error.toString(),
            duration: const Duration(milliseconds: 500),
          );
          return;
        }
        if (result.isSuccess && result.data == true) {
          openCompSnackBar(
            message: isDark ? "LightMode engaged" : "DarkMode engaged",
            duration: const Duration(milliseconds: 500),
          );
        }
      },
    );
  }
}
