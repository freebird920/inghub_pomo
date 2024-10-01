// lib/managers/dialog_manager.dart

import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';

class ModalManager {
  static final ModalManager _instance = ModalManager._internal();
  factory ModalManager() => _instance;

  ModalManager._internal();

  Future<T?> showBottomSheetStateful<T>(StatefulWidget statefulWidget) async {
    final thisContext = navigatorKey.currentContext;
    try {
      if (thisContext == null) {
        throw Exception("context is null");
      }
      final result = await showModalBottomSheet(
        context: thisContext,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => statefulWidget, // `StatefulWidget` 사용
      ).catchError((e) {
        throw Exception("Error showing bottom sheet: $e");
      });
      if (result is! T) {
        throw Exception("Result type mismatch. Expected type: $T");
      }
      return result;
    } catch (e) {
      openCompSnackBar(message: e.toString());
    }
    return null;
  }

  Future<T?> showFutureBottomSheetStateful<T>(
      StatefulWidget statefulWidget) async {
    final currentContext = navigatorKey.currentContext;
    try {
      if (currentContext == null) {
        throw Exception("context is null");
      }
      return await showModalBottomSheet<T>(
        context: currentContext,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => statefulWidget, // `StatefulWidget` 사용
      ).catchError((e) {
        throw Exception("Error showing bottom sheet: $e");
      });
    } catch (e) {
      openCompSnackBar(message: e.toString());
    }
    return null;
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
