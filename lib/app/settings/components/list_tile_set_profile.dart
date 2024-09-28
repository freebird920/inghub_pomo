import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListTileSetProfile extends StatelessWidget {
  const ListTileSetProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text("Profile"),
      subtitle: const Text("프로필 설정 합니다."),
      onTap: () {
        GoRouter.of(context).push("/settings/set_profiles");
      },
    );
  }
}
