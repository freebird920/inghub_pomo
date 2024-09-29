import 'package:flutter/material.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';
import 'package:inghub_pomo/providers/version_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ListTileVersionCheck extends StatelessWidget {
  const ListTileVersionCheck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VersionProvider>(
      builder: (context, versionProvider, _) {
        return ListTile(
          leading: const Icon(Icons.update),
          title: versionProvider.isLoading
              ? const Text("업데이트 확인 중...")
              : versionProvider.currentVersion == null
                  ? const Text("업데이트 확인 불가")
                  : versionProvider.currentVersion ==
                          versionProvider.latestVersion
                      ? const Text("최신 버전입니다.")
                      : const Text("업뎃ㄱㄱㄱㄱㄱ"),
          subtitle: const Text("업데이트 확인합니다."),
          onTap: () async {
            final targetUri = Uri.parse(
              "https://github.com/freebird920/inghub_pomo/releases/latest",
            );
            if (await canLaunchUrl(targetUri) == false) {
              SnackBarManager().showSimpleSnackBar("URL을 열 수 없습니다.");
              return;
            }
            await launchUrl(
              targetUri,
            );
          },
        );
      },
    );
  }
}
