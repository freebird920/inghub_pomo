// lib/managers/dialog_manager.dart

import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';

class DialogManager {
  static final DialogManager _instance = DialogManager._internal();
  factory DialogManager() => _instance;

  DialogManager._internal();

  void showAlertDialog(Widget alertDialog) {
    final thisContext = navigatorKey.currentContext;
    try {
      if (thisContext == null) {
        throw Exception("context is null");
      }
      showDialog(
        context: thisContext,
        builder: (BuildContext context) => alertDialog,
      ).catchError((e) {
        throw Exception("Error showing dialog: $e");
      });
    } catch (e) {
      openCompSnackBar(message: e.toString());
    }
  }
}
