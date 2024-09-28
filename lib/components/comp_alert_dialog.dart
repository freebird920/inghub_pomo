import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/components/comp_snack_bar.dart';

void openAlertDialog({
  Widget? title,
  Widget? content,
  List<Widget>? actions,
}) {
  final BuildContext? context = navigatorKey.currentContext;
  try {
    if (context == null) {
      throw Exception("context is null");
    }
    if (!context.mounted) {
      throw Exception("context is not mounted");
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CompAlertDialog(
          title: title,
          content: content,
          actions: actions,
        );
      },
    );
  } catch (e) {
    openCompSnackBar(message: e.toString());
  }
}

class CompAlertDialog extends StatelessWidget {
  const CompAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
  });
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    List<Widget>? myActions = actions ?? [];
    myActions.add(
      TextButton(
        onPressed: () {
          Navigator.of(navigatorKey.currentContext!).pop();
        },
        child: const Text('닫기'),
      ),
    );
    return AlertDialog(
      title: title,
      content: content,
      actions: myActions,
    );
  }
}
