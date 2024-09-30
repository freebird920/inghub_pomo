import 'package:flutter/material.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:provider/provider.dart';

FractionallySizedBox setProfileBoxBuilder(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  return FractionallySizedBox(
    heightFactor: 0.95,
    widthFactor: 0.9,
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
                    SnackBarManager().showSimpleSnackBar("프로필 이름을 입력하지 않았습니다.");
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
