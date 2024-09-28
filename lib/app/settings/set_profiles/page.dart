import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';

class SetProfilesPage extends StatelessWidget {
  const SetProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Profiles Page"),
        centerTitle: true,
      ),
      bottomNavigationBar: const CompNavbar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Set Profiles Page"),
          ],
        ),
      ),
    );
  }
}
