import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("settings"),
      ),
      body: Center(
        child: ListView(
          children: const [ListTileDarkMode()],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}

class ListTileDarkMode extends StatelessWidget {
  const ListTileDarkMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PreferenceProvider preferenceProvider =
        Provider.of<PreferenceProvider>(context, listen: false);
    return ListTile(
      title: const Text("DarkMode"),
      subtitle: const Text("Set DarkMode"),
      onTap: () {
        preferenceProvider.setPrefBool(key: "theme_dark_mode", value: true);
        openCompSnackBar(context: context, message: "DarkMode Set");
      },
    );
  }
}
