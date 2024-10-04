import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inghub_pomo/classes/inghub_icon_class.dart';
import 'package:inghub_pomo/providers/sqlite_provider.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
import 'package:provider/provider.dart';

class ModalSetPomoType extends StatefulWidget {
  const ModalSetPomoType({
    super.key,
    this.currentPomoType,
  });

  final PomoTypeSchema? currentPomoType;

  @override
  State<ModalSetPomoType> createState() => _ModalSetPomoTypeState();
}

class _ModalSetPomoTypeState extends State<ModalSetPomoType> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _runningTimeController = TextEditingController();
  final _descriptionController = TextEditingController();

  late SqliteProvider _sqliteProvider;
  late Function _navigatorPop;

  late VoidCallback _submitFuntion;

  Icon? _selectedIcon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sqliteProvider = Provider.of<SqliteProvider>(context);
    _navigatorPop = Navigator.of(context).pop;
    if (widget.currentPomoType != null) {
      _nameController.text = widget.currentPomoType!.typeName;
      _runningTimeController.text =
          ((widget.currentPomoType!.runningTime ~/ 60)).toString();
      _descriptionController.text = widget.currentPomoType!.description ?? "";
      _selectedIcon = Icon(
        IconData(widget.currentPomoType!.iconCodePoint,
            fontFamily: "MaterialIcons"),
      );
      _submitFuntion = () async {
        if (_formKey.currentState!.validate()) {
          final pomoType = PomoTypeSchema(
            uuid: widget.currentPomoType!.uuid,
            typeName: _nameController.text,
            runningTime: int.parse(_runningTimeController.text) * 60,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
            iconCodePoint:
                _selectedIcon?.icon?.codePoint ?? Icons.face.codePoint,
          );
          await _sqliteProvider.updatePomoType(pomoType);
          _navigatorPop();
        }
      };
    } else {
      _submitFuntion = () async {
        if (_formKey.currentState!.validate()) {
          final pomoType = PomoTypeSchema(
            typeName: _nameController.text,
            runningTime: int.parse(_runningTimeController.text) * 60,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
            iconCodePoint:
                _selectedIcon?.icon?.codePoint ?? Icons.face.codePoint,
          );
          await _sqliteProvider.insertPomoType(pomoType);
          _navigatorPop();
        }
      };
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _runningTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "뽀모도로 타입 ${widget.currentPomoType != null ? "수정" : "추가"}",
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              autofocus: true,
              validator: (value) => value!.isEmpty ? "이름을 입력해주세요" : null,
              decoration: const InputDecoration(
                hintText: "이름을 입력해주세요",
                label: Text("name"),
              ),
            ),
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _runningTimeController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return "지속 시간을 입력해주세요";
                } else if (int.parse(value) < 1) {
                  return "1분 이상 입력해주세요";
                } else if (int.parse(value) > 6000) {
                  return "6,000분 이하로 입력해주세요";
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: "지속 시간을 입력하십시오.(필수)",
                label: Text("지속시간(분)"),
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "설명을 입력하십시오.",
                label: Text("설명"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("아이콘 선택: "),
                PopupMenuButton(
                  tooltip: "아이콘 선택",
                  icon: _selectedIcon ?? const Icon(Icons.face),
                  itemBuilder: (context) {
                    final iconDropDownMenu = InghubIconClass.allowedIcons.map(
                      (Icon icon) {
                        return PopupMenuItem(
                          value: icon,
                          child: Center(child: icon),
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                        );
                      },
                    ).toList();
                    return iconDropDownMenu;
                  },
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _submitFuntion, child: const Text("Save")),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        )
      ],
    );
  }
}
