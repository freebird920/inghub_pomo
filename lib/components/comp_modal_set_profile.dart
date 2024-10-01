import 'package:flutter/material.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:provider/provider.dart';

/// # [Future<String>?] SetProfileModal
/// - 프로필 추가 모달
/// ### @params
/// - [ProfileSchema] profile: 수정할 프로필 정보
///   - 만약 profile이 존재하면 해당 프로필을 수정합니다.
///   - 만약 profile이 null이면 새로운 프로필을 추가합니다.
/// ### @return
/// - [String] profile.uuid
///   - 프로필 추가/수정 성공 시 프로필의 uuid를 반환합니다.
class SetProfileModal extends StatefulWidget {
  const SetProfileModal({
    super.key,
    this.profile,
  });

  final ProfileSchema? profile;

  @override
  SetProfileModalState createState() => SetProfileModalState();
}

class SetProfileModalState extends State<SetProfileModal> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController profileNameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  late SqliteProvider _databaseProvider;
  late ProfileSchema? _targetProfile;

  void insertProfile(ProfileSchema profile) {
    _databaseProvider.insertProfile(profile);
  }

  @override
  void initState() {
    super.initState();
    profileNameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _databaseProvider = Provider.of<SqliteProvider>(context);
    _targetProfile = widget.profile;
    if (_targetProfile != null) {
      profileNameController.text = _targetProfile!.profileName;
      descriptionController.text = _targetProfile!.description ?? "";
    }
  }

  @override
  void dispose() {
    profileNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      // heightFactor: 0.95,
      // widthFactor: 0.9,
      child: SingleChildScrollView(
        // 키보드 열릴 때 화면 조정
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "${_targetProfile == null ? "ㅇㅋ" : "수정"}프로필 추가",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                    onChanged: null,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    minLines: 1,
                    maxLines: null,
                    controller: descriptionController,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState == null) {
                            SnackBarManager().showSimpleSnackBar(
                                "formKey.currentState is null");
                            return;
                          }
                          if (!formKey.currentState!.validate()) {
                            SnackBarManager()
                                .showSimpleSnackBar("프로필 이름을 입력하지 않았습니다.");
                            return;
                          }
                          ProfileSchema profile = ProfileSchema(
                            uuid: _targetProfile?.uuid,
                            profileName: profileNameController.text,
                            description: descriptionController.text.isEmpty
                                ? null
                                : descriptionController.text,
                            created: _targetProfile != null
                                ? _targetProfile!.created
                                : DateTime.now(),
                            updated: DateTime.now(),
                          );
                          if (_targetProfile != null) {
                            _databaseProvider.updateProfile(profile);
                          } else {
                            _databaseProvider.insertProfile(profile);
                          }
                          Navigator.of(context).pop<String>(profile.uuid);
                        },
                        child: const Text("확인"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop<String?>(null);
                        },
                        child: const Text("취소"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
