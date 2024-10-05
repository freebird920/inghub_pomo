import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/set_pomo/components/comp_pomo_sequence_set.dart';
import 'package:inghub_pomo/app/set_pomo/components/modal_pomo_type.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';

class SetPomoPage extends StatelessWidget {
  const SetPomoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomo 설정"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ModalManager().showBottomSheetWidget(
                const CompPomoType(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: const Center(
        child: Column(
          children: [
            Text("Pomo 설정 페이지"),
            PomoSequenceSet(),
          ],
        ),
      ),
    );
  }
}
