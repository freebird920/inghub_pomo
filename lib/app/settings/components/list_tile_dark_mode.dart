import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';
import 'package:provider/provider.dart';

class ListTileDarkMode extends StatelessWidget {
  const ListTileDarkMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // PreferenceProvider
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context);

    // isDark
    final bool isDark =
        preferenceProvider.getPrefBool("theme_dark_mode") ?? false;

    void openDarkModeSnackBar(String msg) {
      openCompSnackBar(context: context, message: msg);
    }

    return ListTile(
      leading:
          isDark ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
      title: const Text("ThemeMode"),
      subtitle: Text(
          "Current: ${isDark ? "Dark" : "Light"}  Target: ${isDark ? "Light" : "Dark"}"),
      onTap: () async {
        final Result<bool> result = await preferenceProvider.setPrefBool(
            key: "theme_dark_mode", value: !isDark);
        if (result.isError) {
          openDarkModeSnackBar(result.error.toString());
          return;
        }
        if (result.isSuccess && result.data == true) {
          openDarkModeSnackBar(
              isDark ? "LightMode engaged" : "DarkMode engaged");
        }
      },
    );
  }
}
