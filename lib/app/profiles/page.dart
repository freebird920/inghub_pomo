// import material package
import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_modal_builder_set_profile.dart';

// import external library package
import 'package:provider/provider.dart';

// import schema
import 'package:inghub_pomo/schema/profile_schema.dart';

// import provider
import 'package:inghub_pomo/providers/sqlite_provider.dart';

// import manager
import 'package:inghub_pomo/managers/modal_manager.dart';

// import component
import 'package:inghub_pomo/components/comp_navbar.dart';

// HomePage
class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 설정"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ModalManager().showBottomSheet(setProfileBoxBuilder);
            },
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: Center(
        child: Consumer(
          builder: (context, DatabaseProvider sqliteProvider, child) {
            if (sqliteProvider.isLoading == true) {
              return const CircularProgressIndicator();
            }
            if (sqliteProvider.profiles == null ||
                sqliteProvider.profiles!.isEmpty) {
              return TextButton(
                onPressed: () {
                  ModalManager().showBottomSheet(setProfileBoxBuilder);
                },
                child: const Text("프로필 추가하기"),
              );
            }
            return ListView.builder(
              // padding: const EdgeInsets.fromLTRB(
              //   4,
              //   4,
              //   4,
              //   4,
              // ),
              itemCount: sqliteProvider.profiles!.length + 1,
              itemBuilder: (context, index) {
                if (index == sqliteProvider.profiles!.length) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      30, // Left
                      10, // Top
                      30, // Right
                      10, // Bottom
                    ),
                    child: TextButton(
                      onPressed: () {
                        ModalManager().showBottomSheet(setProfileBoxBuilder);
                      },
                      child: const Text(
                        "새 프로필 추가하기",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }
                final ProfileSchema profile = sqliteProvider.profiles![index];
                return ListTile(
                  leading: Text((index + 1).toString()),
                  onTap: () {},
                  title: Text(
                    profile.profileName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "uuid: ${profile.uuid}",
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "created: ${profile.created.toIso8601String()}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      sqliteProvider.removeProfile(profile.uuid);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
