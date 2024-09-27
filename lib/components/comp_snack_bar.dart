import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/layout.dart';

void openCompSnackBar({required String message, Duration? duration}) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "닫기",
        onPressed: () {},
      ),
      duration: duration ?? const Duration(milliseconds: 500),
    ),
  );
}
