// import material package
import 'package:flutter/material.dart';

// import external library package
import 'package:provider/provider.dart';

// import schema
import 'package:inghub_pomo/schema/profile_schema.dart';

// import provider
import 'package:inghub_pomo/providers/sqlite_provider.dart';

// import manager
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';

// import component
import 'package:inghub_pomo/components/comp_navbar.dart';

// HomePage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ModalManager().showBottomSheet(
                bottomBuilder,
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
              builder: (context, DatabaseProvider sqliteProvider, child) {
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "uuid: ${profile.uuid}",
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "created: ${profile.created.toIso8601String()}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            sqliteProvider.removeProfile(profile.uuid);
                          },
                        ),
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

  FractionallySizedBox bottomBuilder(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController profileNameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return FractionallySizedBox(
      // heightFactor: 0.9,
      widthFactor: 0.8,
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            const ListTile(
              title: Text(
                "프로필 추가",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return "Profile Name is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Profile Name(String)*",
                ),
                controller: profileNameController,
                showCursor: true,
                autofocus: true,
              ),
              onTap: () {},
            ),
            ListTile(
              title: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                controller: descriptionController,
                showCursor: true,
                minLines: 1, // 최소 줄 수
                maxLines: null, // 내용에 따라 자동으로 늘어나게 설정
              ),
            ),
            const Divider(),
            ListTile(
              title: TextButton(
                  onPressed: () {
                    if (formKey.currentState == null) {
                      SnackBarManager()
                          .showSimpleSnackBar("formKey.currentState is null");
                    }
                    if (!formKey.currentState!.validate()) {
                      SnackBarManager()
                          .showSimpleSnackBar("프로필 이름을 입력하지 않았습니다.");
                      return;
                    }
                    ProfileSchema profile = ProfileSchema(
                      profileName: profileNameController.text,
                      description: descriptionController.text,
                      created: DateTime.now(),
                      updated: DateTime.now(),
                    );
                    DatabaseProvider sqliteProvider =
                        Provider.of<DatabaseProvider>(context, listen: false);
                    sqliteProvider.insertProfile(profile);

                    Navigator.of(context).pop();
                  },
                  child: const Text("추가")),
            ),
          ],
        ),
      ),
    );
  }
}
