import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';
import 'package:inghub_pomo/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void openThemeColorSeedPicker() {
  final BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    openCompSnackBar(message: "context is null");
    return;
  }
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
  late ThemeProvider themeProvider;
  late Color pickerColor;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
    pickerColor = themeProvider.themeColor;
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
            themeProvider.setThemeColor(pickerColor);

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
