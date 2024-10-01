// lib/managers/dialog_manager.dart

import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';

class ModalManager {
  static final ModalManager _instance = ModalManager._internal();
  factory ModalManager() => _instance;

  ModalManager._internal();

  Future<T?> showBottomSheetStatefulWidget<T>(
      StatefulWidget statefulWidget) async {
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

  Future<T?> showAlertDialog<T>(Widget widget) async {
    final thisContext = navigatorKey.currentContext;
    try {
      if (thisContext == null) {
        throw Exception("context is null");
      }
      final T? result = await showDialog(
        context: thisContext,
        builder: (context) => widget,
      ).catchError((e) {
        throw Exception("Error showing dialog: $e");
      });
      return result;
    } catch (e) {
      openCompSnackBar(message: e.toString());
    }
    return null;
  }
}
