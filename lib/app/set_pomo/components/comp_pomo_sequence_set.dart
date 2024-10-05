import 'package:flutter/material.dart';
import 'package:inghub_pomo/app/set_pomo/components/modal_pomo_type.dart';
import 'package:inghub_pomo/app/set_pomo/components/modal_set_pomo_type.dart';
import 'package:inghub_pomo/classes/inghub_icon_class.dart';
import 'package:inghub_pomo/managers/modal_manager.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

class PomoSequenceSet extends StatefulWidget {
  const PomoSequenceSet({
    super.key,
  });

  @override
  State<PomoSequenceSet> createState() => _PomoSequenceSetState();
}

class _PomoSequenceSetState extends State<PomoSequenceSet> {
  final List<PomoTypeSchema> _pomoSequence = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView.builder(
        itemCount: (_pomoSequence.length),
        shrinkWrap: true,
        footer: ListTile(
          key: const ValueKey("add"),
          title: const Text("추가"),
          onTap: () async {
            final PomoTypeSchema? result = await ModalManager()
                .showBottomSheetWidget(const CompPomoType());
            if (result == null) return;
            setState(() {
              _pomoSequence.add(result);
            });
          },
        ),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _pomoSequence.removeAt(oldIndex);
            _pomoSequence.insert(newIndex, item);
          });
        },
        buildDefaultDragHandles: false,
        header: const ListTile(
          title: Text("Pomo 순서"),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            key: ValueKey(const Uuid().v4()), // 고유 키 생성 및 할당
            subtitle: Text("${_pomoSequence[index].runningTime}분"),
            leading: ReorderableDragStartListener(
              index: index,
              child: IconButton(
                icon: const Icon(
                    CupertinoIcons.line_horizontal_3), // 원하는 아이콘으로 변경
                onPressed: () {},
              ),
            ),
            title: Row(
              children: [
                InghubIconClass.fromCodePoint(
                  _pomoSequence[index].iconCodePoint,
                ).icon,
                Text(_pomoSequence[index].typeName),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(
                  () {
                    _pomoSequence.removeAt(index);
                  },
                );
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
