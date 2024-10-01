// import material package
import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/profiles/components/comp_profiles_page.dart';

// import manager
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';

// import component
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/components/comp_modal_set_profile.dart';

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
            onPressed: () async {
              final String? result = await ModalManager()
                  .showBottomSheetStatefulWidget(const SetProfileModal());
              if (result == null) SnackBarManager().showSimpleSnackBar("취소");
              if (result is String) {
                SnackBarManager().showSimpleSnackBar(result);
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: const CompProfilesPage(),
    );
  }
}

void focusOnProfile(String uuid) {}
