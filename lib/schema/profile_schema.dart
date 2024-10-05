import 'dart:convert';

import 'package:inghub_pomo/classes/sqlite_schema_class.dart';
import 'package:inghub_pomo/schema/pomo_sequence_schema.dart';
import 'package:inghub_pomo/schema/pomo_type_schema.dart';
import 'package:uuid/uuid.dart';

class ProfileSchema {
  final String uuid;
  String profileName;
  String? description;
  DateTime created; // Flutter에서는 DateTime 사용
  DateTime updated;
  String? currentPomo;
  PomoSequenceSchema? pomoSequence;

  // Uuid 인스턴스 생성
  static const Uuid _uuid = Uuid();

  ProfileSchema({
    String? uuid, // uuid는 선택적 파라미터
    required this.profileName,
    required this.created,
    required this.updated,
    this.description,
    this.currentPomo,
    this.pomoSequence,
  }) : uuid = uuid ?? _uuid.v4(); // uuid가 없을 경우 자동 생성
// 객체를 맵으로 변환
  Map<String, dynamic> get toMap {
    return {
      "uuid": uuid,
      "profileName": profileName,
      "description": description,
      "created": created.toIso8601String(), // DateTime을 TEXT로 변환
      "updated": updated.toIso8601String(),
      "currentPomo": currentPomo,
      "pomoSequence": pomoSequence != null
          ? jsonEncode(pomoSequence!.toMap)
          : null, // JSON으로 인코딩
    };
  }

// 맵에서 객체로 변환하는 팩토리 메서드 추가
  factory ProfileSchema.fromMap(Map<String, dynamic> map) {
    return ProfileSchema(
      uuid: map["uuid"],
      profileName: map["profileName"],
      description: map["description"],
      created: DateTime.parse(map["created"]), // TEXT를 DateTime으로 변환
      updated: DateTime.parse(map["updated"]),
      currentPomo: map["currentPomo"],
      pomoSequence: map["pomoSequence"] != null
          ? PomoSequenceSchema.fromMap(
              jsonDecode(map["pomoSequence"])) // JSON을 Map으로 디코딩
          : null,
    );
  }

  // 스키마 생성용 SQL 타입 맵
  static SqliteSchema get schema => SqliteSchema(
        tableName: "profiles",
        fields: {
          "uuid": "TEXT PRIMARY KEY",
          "profileName": "TEXT NOT NULL",
          "description": "TEXT",
          "created": "TEXT NOT NULL",
          "updated": "TEXT NOT NULL",
          "currentPomo": "TEXT",
          "pomoSequence": "TEXT",
        },
      );

  static ProfileSchema generateDefault({
    String? profileName = "Default Profile",
    String? description =
        "This is a simple example profile. Please edit to your taste.",
  }) {
    DateTime now = DateTime.now();
    List<PomoTypeSchema> d = PomoTypeSchema.defaultPomoTypes;
    return ProfileSchema(
      profileName: profileName!,
      description: description,
      created: now,
      updated: now,
      currentPomo: null,
      pomoSequence: PomoSequenceSchema(
        uuid: const Uuid().v4(),
        pomoTypes: [
          d[0],
          d[1],
          d[0],
          d[1],
          d[0],
          d[1],
          d[0],
          d[2],
        ],
      ),
    );
  }
}
