import 'package:flutter/material.dart';

void openCompSnackBar(
    {required BuildContext context, required String message}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: "닫기",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  });
}
