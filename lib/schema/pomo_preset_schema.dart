import 'dart:convert';

import 'package:inghub_pomo/classes/sqlite_schema_class.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';

class PomoPresetSchema {
  final String uuid;
  final List<PomoTypeSchema> pomoTypes;

  PomoPresetSchema({
    required this.uuid,
    required this.pomoTypes,
  });

  // pomoTypes를 JSON 문자열로 변환하여 저장
  Map<String, dynamic> get toMap {
    return {
      "uuid": uuid,
      "pomoTypes": jsonEncode(pomoTypes.map((e) => e.toMap).toList()),
    };
  }

  String get toJson {
    return jsonEncode(toMap);
  }

  factory PomoPresetSchema.fromMap(Map<String, dynamic> map) {
    return PomoPresetSchema(
      uuid: map["uuid"],
      pomoTypes: (jsonDecode(map["pomoTypes"]) as List)
          .map((e) => PomoTypeSchema.fromMap(e))
          .toList(),
    );
  }

  static SqliteSchema get schema => SqliteSchema(
        tableName: "pomo_presets",
        fields: {
          "uuid": "TEXT PRIMARY KEY",
          "pomoTypes": "TEXT NOT NULL",
        },
      );
}
