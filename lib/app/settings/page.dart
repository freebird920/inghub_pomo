import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/settings/components/list_tile_dark_mode.dart';
import 'package:inghub_pomo/components/comp_modal_color_picker.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';
import 'package:provider/provider.dart';

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
          children: const [
            ListTileDarkMode(),
            ListTileColorPicker(),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}

class ListTileColorPicker extends StatefulWidget {
  const ListTileColorPicker({
    super.key,
  });

  @override
  State<ListTileColorPicker> createState() => _ListTileColorPickerState();
}

class _ListTileColorPickerState extends State<ListTileColorPicker> {
  late PreferenceProvider preferenceProvider;
  late Color pickerColor;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    preferenceProvider = Provider.of<PreferenceProvider>(context);
    pickerColor = Color(
        preferenceProvider.getPrefInt("theme_color") ?? Colors.indigo.value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "■",
            style: TextStyle(color: pickerColor),
          ),
          const Text(" ThemeColor: "),
          Text('#${pickerColor.value.toRadixString(16)}'),
        ],
      ),
      subtitle: const Text("Change the theme color"),
      onTap: () {
        openThemeColorSeedPicker(context: context);
      },
    );
  }
}
