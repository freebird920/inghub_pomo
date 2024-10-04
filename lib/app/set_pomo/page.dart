import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/set_pomo/components/modal_pomo_type.dart';
import 'package:inghub_pomo/app/set_pomo/components/modal_set_pomo_type.dart';
import 'package:inghub_pomo/classes/inghub_icon_class.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';

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
                const CompPomoType(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: const Center(
        child: Column(
          children: [
            Text("Pomo 설정 페이지"),
            PomoSequenceList(),
          ],
        ),
      ),
    );
  }
}

class PomoSequenceList extends StatefulWidget {
  const PomoSequenceList({
    super.key,
  });

  @override
  State<PomoSequenceList> createState() => _PomoSequenceListState();
}

class _PomoSequenceListState extends State<PomoSequenceList> {
  final List<PomoTypeSchema> _pomoSequence = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView.builder(
        itemCount: (_pomoSequence.length + 1),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _pomoSequence.removeAt(oldIndex);
            _pomoSequence.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          if (index == _pomoSequence.length) {
            return ListTile(
              key: const ValueKey("add"),
              title: const Text("추가"),
              onTap: () async {
                final PomoTypeSchema? result =
                    await ModalManager().showAlertDialog(
                  const CompPomoType(),
                );
                if (result != null) return;
                setState(() {
                  _pomoSequence.add(result!);
                });
              },
            );
          }
          return ListTile(
            key: ValueKey(_pomoSequence[index].uuid), // 고유 키 필요
            leading: InghubIconClass.fromCodePoint(
              _pomoSequence[index].iconCodePoint,
            ).icon,
            title: Text(_pomoSequence[index].typeName),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _pomoSequence.removeAt(index);
                });
              },
            ),
            onTap: () {
              ModalManager().showAlertDialog(
                const ModalSetPomoType(),
              );
            },
          );
        },
      ),
    );
  }
}
