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

  Map<String, dynamic> get toMap {
    return {
      "uuid": uuid,
      "pomoTypes": pomoTypes
          .map(
            (e) => e.toMap,
          )
          .toList(),
    };
  }

  String get toJson {
    return jsonEncode(
      pomoTypes
          .map(
            (PomoTypeSchema e) => e.toMap,
          )
          .toList(),
    );
  }

  factory PomoPresetSchema.fromMap(Map<String, dynamic> map) {
    return PomoPresetSchema(
      uuid: map["uuid"],
      pomoTypes: (map["pomoTypes"] as List)
          .map((e) => PomoTypeSchema.fromMap(e))
          .toList(),
    );
  }

  static SqliteSchema get schema => SqliteSchema(
        tableName: "pomo_sequences",
        fields: {
          "uuid": "TEXT PRIMARY KEY",
          "pomoTypes": "TEXT NOT NULL",
        },
      );
}
