import 'package:flutter/material.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';

class PopupMenuPomoType extends StatelessWidget {
  const PopupMenuPomoType({
    super.key,
    required this.pomoType,
  });

  final PomoTypeSchema pomoType;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enabled: pomoType.isDefault ? false : true,
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: "edit",
            child: Text("수정"),
          ),
          const PopupMenuItem(
            value: "delete",
            child: Text("삭제"),
          ),
        ];
      },
    );
  }
}
