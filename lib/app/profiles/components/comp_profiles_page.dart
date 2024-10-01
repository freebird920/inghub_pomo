// import material
import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';

// import external library packages
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// import managers
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';

// import providers
import 'package:inghub_pomo/providers/profile_provider.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';

// import schema
import 'package:inghub_pomo/schema/profile_schema.dart';

// import components
import 'package:inghub_pomo/components/comp_modal_set_profile.dart';

class CompProfilesPage extends StatefulWidget {
  const CompProfilesPage({
    super.key,
  });

  @override
  State<CompProfilesPage> createState() => _CompProfilesPageState();
}

class _CompProfilesPageState extends State<CompProfilesPage> {
  // ScrollController
  String? _focusProfileUuid;

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  // Late ProfileProvider
  late ProfileProvider _profileProvider;
  late SqliteProvider _sqliteProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _profileProvider = Provider.of<ProfileProvider>(context);
    _sqliteProvider = Provider.of<SqliteProvider>(context);

    _focusProfileUuid ??= _profileProvider.currentProfileUuid;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_focusProfileUuid != null) {
          _scrollToProfile(
            uuid: _focusProfileUuid!,
            profiles: _sqliteProvider.profiles!,
          );
        }
      },
    );
  }

  void _scrollToProfile({
    required String uuid,
    required List<ProfileSchema>? profiles,
  }) {
    if (profiles == null) {
      return;
    }
    final int index = profiles.indexWhere((element) => element.uuid == uuid);
    if (index != -1) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCirc,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemCount: _sqliteProvider.profiles!.length + 1,
      itemBuilder: (context, index) {
        if (index == _sqliteProvider.profiles!.length) {
          return TextButton(
            onPressed: () async {
              final result = await ModalManager()
                  .showBottomSheetStateful<String?>(const SetProfileModal());
              if (result == null) {
                SnackBarManager().showSimpleSnackBar("취소");
                return;
              }
              _focusProfileUuid = result;
              SnackBarManager().showSimpleSnackBar(result);
            },
            child: const Text(
              "새 프로필 추가하기",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        final ProfileSchema profile = _sqliteProvider.profiles![index];
        return ListTile(
          leading: _profileProvider.currentProfileUuid == profile.uuid
              ? const Icon(Icons.check_circle_outline)
              : const Icon(Icons.circle_outlined),
          onTap: () async {
            Result<String> result =
                await _profileProvider.setCurrentProfileUuid(profile.uuid);
            if (result.isError) {
              SnackBarManager().showSimpleSnackBar(result.error.toString());
              return;
            }
            if (result.isSuccess) {
              SnackBarManager().showSimpleSnackBar(result.successData);
              _focusProfileUuid = profile.uuid;
              return;
            }
            return;
          },
          title: Text(
            profile.profileName,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
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
              if (_profileProvider.currentProfileUuid == profile.uuid) {
                _profileProvider.removeCurrentProfileUuid();
              }
              _sqliteProvider.removeProfile(profile.uuid);
            },
          ),
        );
      },
    ));
  }
}
