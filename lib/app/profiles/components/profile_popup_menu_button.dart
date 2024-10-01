import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/profiles/components/alert_dialog_delete_profile.dart';
import 'package:inghub_pomo/components/comp_modal_set_profile.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';

enum ProfilePopupMenuButtonEnum {
  edit,
  delete,
  text,
}

class ProfilePopupMenuButton extends StatelessWidget {
  const ProfilePopupMenuButton({
    super.key,
    required this.profile,
  });
  final ProfileSchema profile;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProfilePopupMenuButtonEnum>(
      icon: const Icon(Icons.more_vert), // 여기에 원하는 아이콘 넣으면 됨
      onSelected: (value) async {
        switch (value) {
          case ProfilePopupMenuButtonEnum.edit:
            ModalManager().showBottomSheetStatefulWidget<String?>(
              SetProfileModal(
                profile: profile,
              ),
            );
            break;
          case ProfilePopupMenuButtonEnum.delete:
            ModalManager().showAlertDialog(
              AlertDialogDeleteProfile(
                profile: profile,
              ),
            );
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<ProfilePopupMenuButtonEnum>>[
        const PopupMenuItem<ProfilePopupMenuButtonEnum>(
          value: ProfilePopupMenuButtonEnum.edit,
          child: Text('수정'),
        ),
        const PopupMenuItem<ProfilePopupMenuButtonEnum>(
          value: ProfilePopupMenuButtonEnum.delete,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              fontFamily: "NotoSansKR",
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          child: Text("삭제"),
        ),
      ],
    );
  }
}
