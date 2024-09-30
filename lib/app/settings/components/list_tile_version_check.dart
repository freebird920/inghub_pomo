import 'package:flutter/material.dart';
import 'package:inghub_pomo/providers/version_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            await launchUrlString(
              "https://github.com/freebird920/inghub_pomo/releases/latest",
            );
            return;
          },
        );
      },
    );
  }
}
