import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/layout.dart';

void openCompSnackBar({required String message, Duration? duration}) {
  scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(milliseconds: 1000),
      action: SnackBarAction(
        label: "닫기",
        onPressed: () {
          scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
        },
      ),
    ),
  );
}
