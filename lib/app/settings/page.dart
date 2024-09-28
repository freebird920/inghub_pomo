// import material
import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_alert_dialog.dart';

// import components
import 'package:inghub_pomo/components/comp_navbar.dart';

// import local components
import 'package:inghub_pomo/app/settings/components/list_tile_set_profile.dart';
import 'package:inghub_pomo/app/settings/components/list_tile_update_check.dart';
import 'package:inghub_pomo/app/settings/components/list_tile_color_picker.dart';
import 'package:inghub_pomo/app/settings/components/list_tile_dark_mode.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("설정"),
      ),
      body: Center(
        child: ListView(
          children: [
            const ListTileSetProfile(),
            const ListTileDarkMode(),
            const ListTileColorPicker(),
            const ListTileUpdateCheck(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              subtitle: const Text("About this app"),
              onTap: () {
                openAlertDialog(
                  title: const Text("About"),
                  content: const Text("This is a simple app"),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
