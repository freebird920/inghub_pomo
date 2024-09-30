import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_modal_color_picker.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:provider/provider.dart';

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
        ModalManager().showAlertDialog(const CompModalColorPicker());
      },
    );
  }
}
