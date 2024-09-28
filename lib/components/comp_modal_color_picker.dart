import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';
import 'package:inghub_pomo/providers/preference_provider.dart';
import 'package:provider/provider.dart';

void openThemeColorSeedPicker({
  required BuildContext context,
}) {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      try {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CompModalColorPicker();
            },
          );
        } else {
          throw Exception(
            "Exception: openCompModalColorPicker => context is not mounted",
          );
        }
      } catch (e) {
        openCompSnackBar(message: e.toString());
      }
    },
  );
}

class CompModalColorPicker extends StatefulWidget {
  const CompModalColorPicker({
    super.key,
  });

  @override
  State<CompModalColorPicker> createState() => _CompModalColorPickerState();
}

class _CompModalColorPickerState extends State<CompModalColorPicker> {
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
    return AlertDialog(
      title: const Text("Theme Color Picker"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (value) => setState(
            () {
              pickerColor = value;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Select"),
          onPressed: () {
            preferenceProvider.setPrefInt(
              key: "theme_color",
              value: pickerColor.value,
            );
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("취소"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
