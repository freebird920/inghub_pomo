import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("홈페이지"),
        centerTitle: true,
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
