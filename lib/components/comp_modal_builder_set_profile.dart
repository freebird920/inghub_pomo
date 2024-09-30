import 'package:flutter/material.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';

Future<ProfileSchema?> openProfileModal(BuildContext context) async {
  final result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 키보드가 올라올 때 스크롤 조절
    builder: (context) => const SetProfileBox(),
  );
  if (result != null) {
    SnackBarManager().showSimpleSnackBar("프로필 추가 완료");
  }
  return result;
}

class SetProfileBox extends StatefulWidget {
  const SetProfileBox({super.key});

  @override
  _SetProfileBoxState createState() => _SetProfileBoxState();
}

class _SetProfileBoxState extends State<SetProfileBox> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.95,
      widthFactor: 0.9,
      child: SingleChildScrollView(
        // 키보드 열릴 때 화면 조정
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true, // 높이를 내용에 맞게 줄임
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
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().isEmpty) {
                        return "Profile Name is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Profile Name(String)*",
                    ),
                    controller: profileNameController,
                    autofocus: true,
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    controller: descriptionController,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: TextButton(
                    onPressed: () {
                      if (formKey.currentState == null) {
                        SnackBarManager()
                            .showSimpleSnackBar("formKey.currentState is null");
                        return;
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
                      Navigator.of(context).pop<ProfileSchema>(profile);
                    },
                    child: const Text("추가"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    profileNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
