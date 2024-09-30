// lib/managers/dialog_manager.dart

import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';

class ModalManager {
  static final ModalManager _instance = ModalManager._internal();
  factory ModalManager() => _instance;

  ModalManager._internal();
  void showBottomSheet(WidgetBuilder bottomSheet) {
    final thisContext = navigatorKey.currentContext;
    try {
      if (thisContext == null) {
        throw Exception("context is null");
      }
      showModalBottomSheet(
        context: thisContext,
        isScrollControlled: true,
        showDragHandle: true,
        builder: bottomSheet,
      ).catchError((e) {
        throw Exception("Error showing bottom sheet: $e");
      });
    } catch (e) {
      openCompSnackBar(message: e.toString());
    }
  }

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
