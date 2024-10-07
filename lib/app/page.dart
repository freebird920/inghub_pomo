import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/profiles/components/comp_profiles_page.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ProfileProvider _profileProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _profileProvider = Provider.of<ProfileProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              ModalManager().showBottomSheetWidget(
                const CompProfilesPage(),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_profileProvider.currentProfile?.profileName ?? "없음"),
            Text(
              _profileProvider.currentProfile?.updated.toIso8601String() ??
                  "없음",
            ),
            // pomoTypes 리스트가 null이 아닐 경우에만 추가
            if (_profileProvider.currentProfile?.pomoPreset?.pomoTypes != null)
              ..._profileProvider.currentProfile!.pomoPreset!.pomoTypes.map(
                (element) => Text(element.typeName),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
