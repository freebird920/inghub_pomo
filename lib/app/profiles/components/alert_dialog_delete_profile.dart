import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';
import 'package:inghub_pomo/providers/profile_provider.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:provider/provider.dart';

class AlertDialogDeleteProfile extends StatelessWidget {
  const AlertDialogDeleteProfile({
    super.key,
    required this.profile,
  });
  final ProfileSchema profile;

  @override
  Widget build(BuildContext context) {
    void navigatorPop() {
      Navigator.of(context).pop();
    }

    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final SqliteProvider sqliteProvider = Provider.of<SqliteProvider>(context);
    return AlertDialog(
      scrollable: true,
      title: Text('${profile.profileName} 프로필 삭제하겠습니까?'),
      content: Column(
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            subtitle: const Text(
              "uuid",
              textAlign: TextAlign.center,
            ),
            title: Text(
              profile.uuid,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            subtitle: const Text(
              "프로필이름",
              textAlign: TextAlign.center,
            ),
            title: Text(
              profile.profileName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ListTile(
            leading: const Text("프로필 이름"),
            title: Text(
              profile.profileName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          profile.description != null
              ? ListTile(
                  leading: Text(
                    profile.description!,
                    maxLines: null,
                  ),
                  title: Text(
                    profile.profileName,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : const SizedBox(),
          ListTile(
            leading: const Text("만든시간"),
            title: Text(profile.created.toIso8601String()),
          ),
          ListTile(
            leading: const Text("프로필 이름"),
            title: Text(
              profile.profileName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(profile.updated.toIso8601String()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              if (profileProvider.currentProfileUuid == profile.uuid) {
                profileProvider.removeCurrentProfileUuid();
              }
              final Result result =
                  await sqliteProvider.removeProfile(profile.uuid);
              if (result.isError) {
                SnackBarManager().showSimpleSnackBar(result.error.toString());
                return;
              }
              if (result.isSuccess) {
                SnackBarManager()
                    .showSimpleSnackBar("다음 프로필이 삭제됨: ${result.successData}");
                return;
              }
            } finally {
              navigatorPop();
            }
          },
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll<Color>(
                Theme.of(context).colorScheme.error),
            backgroundColor: WidgetStatePropertyAll<Color>(
                Theme.of(context).colorScheme.errorContainer),
          ),
          child: const Text("삭제"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("취소"),
        ),
      ],
    );
  }
}
