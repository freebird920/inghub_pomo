import 'package:flutter/material.dart';
import 'package:inghub_pomo/providers/profile_provider.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/profile_schema.dart';
import 'package:provider/provider.dart';

class CompModalSelectProfile extends StatefulWidget {
  const CompModalSelectProfile({super.key});

  @override
  State<CompModalSelectProfile> createState() => _CompModalSelectProfileState();
}

class _CompModalSelectProfileState extends State<CompModalSelectProfile> {
  late ProfileProvider _profileProvider;
  late SqliteProvider _sqliteProvider;
  List<ProfileSchema>? _profiles;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileProvider = Provider.of<ProfileProvider>(context);
    _sqliteProvider = Provider.of<SqliteProvider>(context);
    _profiles = _sqliteProvider.profiles;
  }

  @override
  Widget build(BuildContext context) {
    if (_profiles?.isEmpty == true || _profiles == null) {
      return Center(
        child: TextButton(onPressed: () {}, child: const Text("프로필이 없습니다.")),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _profiles!.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(_profiles![index].profileName),
          onTap: () {
            _profileProvider.setCurrentProfileUuid(_profiles![index].uuid);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
