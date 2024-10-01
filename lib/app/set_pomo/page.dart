import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/inghub_icon_class.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
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
                  for (var element in PomoTypeSchema.defaultPomoTypes) {
                    await _sqliteProvider.insertPomoType(
                      element,
                    );
                  }
                },
                child: const Text("기본추가요")),
            TextButton(
              onPressed: () async {
                for (var element in PomoTypeSchema.defaultPomoTypes) {
                  final result = await _sqliteProvider.insertPomoType(element);
                  if (result.error != null) {
                    // 에러 처리
                    print("Error inserting PomoType: ${result.error}");
                  }
                }
              },
              child: const Text("기본추가요2"),
            ),
            Expanded(
              child: _sqliteProvider.pomoTypes != null &&
                      _sqliteProvider.pomoTypes!.isNotEmpty
                  ? ListView.builder(
                      itemCount: _sqliteProvider.pomoTypes!.length,
                      itemBuilder: (context, index) {
                        final pomoType = _sqliteProvider.pomoTypes?[index];
                        final Icon myIcon = InghubIconClass.fromCodePoint(
                                pomoType!.iconCodePoint)
                            .icon;
                        return ListTile(
                          leading: myIcon,
                          title: Text("Pomo Type $index"),
                          subtitle: Text(
                            _sqliteProvider.pomoTypes?[index].typeName ??
                                "No Data",
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
