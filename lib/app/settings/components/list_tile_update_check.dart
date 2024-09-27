import 'package:flutter/material.dart';

class ListTileUpdateCheck extends StatelessWidget {
  const ListTileUpdateCheck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.update),
      title: const Text("업데이트"),
      subtitle: const Text("업데이트 확인합니다."),
      onTap: () {},
    );
  }
}
