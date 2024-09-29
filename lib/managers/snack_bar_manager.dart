import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/utils/keys.dart';

class SnackBarManager {
  static final SnackBarManager _instance = SnackBarManager._internal();

  factory SnackBarManager() => _instance;

  SnackBarManager._internal();

  void showSimpleSnackBar(String message) {
    final currentState = scaffoldMessengerKey.currentState;

    try {
      if (currentState == null) {
        throw Exception("currentState is null");
      }
      currentState.clearSnackBars();
      // currentState.hideCurrentSnackBar();
      currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 500),
          action: SnackBarAction(
            label: "닫기",
            onPressed: () {
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
          ),
        ),
      );
    } catch (e) {
      return;
    }
  }

  void showSnackBar(
      String message, AlertDialog alertDialog, SnackBar snackBar) {
    final currentState = scaffoldMessengerKey.currentState;

    try {
      if (currentState == null) {
        throw Exception("currentState is null");
      }
      currentState.clearSnackBars();
      // currentState.hideCurrentSnackBar();
      currentState.showSnackBar(snackBar);
    } catch (e) {
      showSimpleSnackBar(e.toString());
    }
  }
}
