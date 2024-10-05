import 'dart:convert';

import 'package:inghub_pomo/classes/sqlite_schema_class.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';

class PomoSequenceSchema {
  final String uuid;
  final List<PomoTypeSchema> pomoTypes;

  PomoSequenceSchema({
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

  String get pomoTypesJson {
    return jsonEncode(
      pomoTypes
          .map(
            (PomoTypeSchema e) => e.toMap,
          )
          .toList(),
    );
  }

  factory PomoSequenceSchema.fromMap(Map<String, dynamic> map) {
    return PomoSequenceSchema(
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
