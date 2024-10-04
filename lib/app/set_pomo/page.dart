import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/set_pomo/components/modal_set_pomo_type.dart';
import 'package:inghub_pomo/app/set_pomo/components/popup_menu_pomo_type.dart';
import 'package:inghub_pomo/classes/inghub_icon_class.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:provider/provider.dart';

class SetPomoPage extends StatelessWidget {
  const SetPomoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomo 설정"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ModalManager().showBottomSheetWidget(
                const SetPomoTypeBox(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: Center(
        child: Column(
          children: [
            const Text("Pomo 설정 페이지"),
            ElevatedButton(
              onPressed: () {},
              child: const Text("돌아가기"),
            ),
          ],
        ),
      ),
    );
  }
}

class SetPomoTypeBox extends StatefulWidget {
  const SetPomoTypeBox({
    super.key,
  });

  @override
  State<SetPomoTypeBox> createState() => _SetPomoTypeBoxState();
}

class _SetPomoTypeBoxState extends State<SetPomoTypeBox> {
  late SqliteProvider _sqliteProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sqliteProvider = Provider.of<SqliteProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                ModalManager().showAlertDialog(
                  const ModalSetPomoType(),
                );
              },
              child: const Text("뽀모도로 타입 추가 모달 열기"),
            ),
            Expanded(
              child: _sqliteProvider.pomoTypes != null &&
                      _sqliteProvider.pomoTypes!.isNotEmpty
                  ? ListView.builder(
                      itemCount: _sqliteProvider.pomoTypes!.length,
                      itemBuilder: (context, index) {
                        final pomoType = _sqliteProvider.pomoTypes?[index];
                        Icon myIcon = InghubIconClass.fromCodePoint(
                                pomoType!.iconCodePoint)
                            .icon;

                        return ListTile(
                          trailing: PopupMenuPomoType(pomoType: pomoType),
                          leading: myIcon,
                          title: Text(
                            '${pomoType.typeName}${pomoType.isDefault ? "*" : ""} ${pomoType.runningTime ~/ 60}분',
                          ),
                          subtitle: Text(
                            _sqliteProvider.pomoTypes?[index].description ?? "",
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No Pomo Types found"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
