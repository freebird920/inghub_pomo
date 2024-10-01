import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_modal_color_picker.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ListTileColorPicker extends StatefulWidget {
  const ListTileColorPicker({
    super.key,
  });

  @override
  State<ListTileColorPicker> createState() => _ListTileColorPickerState();
}

class _ListTileColorPickerState extends State<ListTileColorPicker> {
  late ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
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
            style: TextStyle(color: themeProvider.themeColor),
          ),
          const Text(" ThemeColor: "),
          Text('#${themeProvider.themeColor.value.toRadixString(16)}'),
        ],
      ),
      subtitle: const Text("Change the theme color"),
      onTap: () {
        ModalManager().showAlertDialog(
          const CompModalColorPicker(),
        );
      },
    );
  }
}
