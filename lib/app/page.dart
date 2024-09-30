import 'package:flutter/material.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SqliteProvider sqliteProvider = Provider.of<SqliteProvider>(context);

    sqliteProvider.init();
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              sqliteProvider.insertProfile(
                ProfileSchema(
                  profileName: "test",
                  created: DateTime.now(),
                  updated: DateTime.now(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: Center(
        child: Column(
          children: [
            Consumer(
              builder: (context, SqliteProvider sqliteProvider, child) {
                if (sqliteProvider.isLoading == true) {
                  return const CircularProgressIndicator();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: sqliteProvider.profiles?.length ?? 0,
                    itemBuilder: (context, index) {
                      final ProfileSchema profile =
                          sqliteProvider.profiles![index];
                      return ListTile(
                        leading: Text(index.toString()),
                        title: Text(profile.profileName),
                        subtitle: Text(profile.created.toIso8601String()),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
