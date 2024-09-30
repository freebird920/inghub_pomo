import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        centerTitle: true,
      ),
      bottomNavigationBar: const CompNavbar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Profile Page"),
          ],
        ),
      ),
    );
  }
}
