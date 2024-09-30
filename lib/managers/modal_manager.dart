// lib/managers/dialog_manager.dart

import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';

class ModalManager {
  static final ModalManager _instance = ModalManager._internal();
  factory ModalManager() => _instance;

  ModalManager._internal();
  void showStatefulBottomSheet(StatefulWidget bottomSheet) {
    final thisContext = navigatorKey.currentContext;
    try {
      if (thisContext == null) {
        throw Exception("context is null");
      }
      showModalBottomSheet(
        context: thisContext,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => bottomSheet, // `StatefulWidget` 사용
      ).catchError((e) {
        throw Exception("Error showing bottom sheet: $e");
      });
    } catch (e) {
      openCompSnackBar(message: e.toString());
    }
  }

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

  void showAlertDialog(WidgetBuilder alertDialogBuilder) {
    final thisContext = navigatorKey.currentContext;
    try {
      if (thisContext == null) {
        throw Exception("context is null");
      }
      showDialog(
        context: thisContext,
        builder: alertDialogBuilder,
      ).catchError((e) {
        throw Exception("Error showing dialog: $e");
      });
    } catch (e) {
      openCompSnackBar(message: e.toString());
    }
  }
}
