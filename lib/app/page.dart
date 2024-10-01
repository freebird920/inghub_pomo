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
    print(Icons.ac_unit.codePoint);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(IconData(57399, fontFamily: 'MaterialIcons')),
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
            Text(_profileProvider.currentProfileUuid ?? "Home"),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
