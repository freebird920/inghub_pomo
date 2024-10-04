import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/set_pomo/components/modal_set_pomo_type.dart';
import 'package:inghub_pomo/classes/inghub_icon_class.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
import 'package:provider/provider.dart';

enum PomoTypePopupMenuButtonEnum {
  edit,
  delete,
}

class PopupMenuPomoType extends StatelessWidget {
  const PopupMenuPomoType({
    super.key,
    required this.pomoType,
  });

  final PomoTypeSchema pomoType;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PomoTypePopupMenuButtonEnum>(
      onSelected: (value) {
        switch (value) {
          case PomoTypePopupMenuButtonEnum.edit:
            ModalManager().showAlertDialog(
              ModalSetPomoType(
                currentPomoType: pomoType,
              ),
            );
            break;
          case PomoTypePopupMenuButtonEnum.delete:
            ModalManager().showAlertDialog(
              AlertDialogDeletePomoType(
                pomoType: pomoType,
              ),
            );
            break;
        }
      },
      enabled: pomoType.isDefault ? false : true,
      itemBuilder: (context) {
        return [
          const PopupMenuItem<PomoTypePopupMenuButtonEnum>(
            value: PomoTypePopupMenuButtonEnum.edit,
            child: Text("수정"),
          ),
          PopupMenuItem<PomoTypePopupMenuButtonEnum>(
            value: PomoTypePopupMenuButtonEnum.delete,
            child: Text(
              "삭제",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ];
      },
    );
  }
}

class AlertDialogDeletePomoType extends StatelessWidget {
  const AlertDialogDeletePomoType({
    super.key,
    required this.pomoType,
  });

  final PomoTypeSchema pomoType;

  @override
  Widget build(BuildContext context) {
    void navigatorPop() {
      Navigator.of(context).pop();
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InghubIconClass.fromCodePoint(pomoType.iconCodePoint).icon,
          const Text(
            "횐님,, 삭제.",
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      content: Text(
        "지금 당신은 ${pomoType.typeName}을 삭제하려고 합니다. 이 작업은 되돌릴 수 없습니다.",
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          onPressed: () async {
            try {
              final sqliteProvider =
                  Provider.of<SqliteProvider>(context, listen: false);
              final result = await sqliteProvider.removePomoType(pomoType.uuid);
              if (result.isError) {
                throw result.error!;
              }
              if (result.isNull || !result.isSuccess) {
                throw "삭제할 수 없습니다.";
              }

              SnackBarManager().showSimpleSnackBar(result.isSuccess
                  ? "${result.successData}가 성공적으로 삭제되었습니다."
                  : "삭제에 실패했습니다.");
              navigatorPop();
            } catch (e) {
              SnackBarManager().showSimpleSnackBar(e.toString());
            }
          },
          child: Text(
            "삭제",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            navigatorPop();
          },
          child: const Text("취소"),
        ),
      ],
    );
  }
}
