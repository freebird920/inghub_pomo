import 'dart:convert';

import 'package:inghub_pomo/classes/sqlite_schema_class.dart';
import 'package:inghub_pomo/schema/pomo_sequence_schema.dart';
import 'package:uuid/uuid.dart';

class PomoSchema {
  final String uuid;
  final PomoSequenceSchema pomoSequence;
  int pomoIndex;
  String pomoName;
  String profileUuid;
  String? description;
  DateTime created; // Flutter에서는 DateTime 사용
  DateTime updated;

  // Uuid 인스턴스 생성
  static const Uuid _uuid = Uuid();

  PomoSchema({
    String? uuid, // uuid는 선택적 파라미터
    required this.pomoSequence,
    required this.profileUuid,
    this.pomoIndex = 0,
    required this.created,
    required this.updated,
    this.description,
    required this.pomoName,
  }) : uuid = uuid ?? _uuid.v4(); // uuid가 없을 경우 자동 생성

  // 객체를 맵으로 변환
  Map<String, dynamic> get toMap {
    return {
      "uuid": uuid,
      "profileUuid": profileUuid,
      "pomoIndex": pomoIndex,
      "description": description,
      "currentPomo": pomoName,
      "created": created.toIso8601String(), // DateTime을 TEXT로 변환
      "updated": updated.toIso8601String(),
      "pomoSequence": pomoSequence.toMap,
    };
  }

  // 맵에서 객체로 변환하는 팩토리 메서드 추가
  factory PomoSchema.fromMap(Map<String, dynamic> map) {
    return PomoSchema(
      uuid: map["uuid"],
      profileUuid: map["profileName"],
      pomoName: map["currentPomo"],
      description: map["description"],
      created: DateTime.parse(map["created"]), // TEXT를 DateTime으로 변환
      updated: DateTime.parse(map["updated"]),
      pomoSequence: PomoSequenceSchema.fromMap(
        jsonDecode(map["pomoSequence"]),
      ), // JSON을 Map으로 디코딩
    );
  }

  // 스키마 생성용 SQL 타입 맵
  static SqliteSchema get schema => SqliteSchema(
        tableName: "profiles",
        fields: {
          "uuid": "TEXT PRIMARY KEY",
          "profileName": "TEXT NOT NULL",
          "description": "TEXT",
          "currentPomo": "TEXT",
          "created": "TEXT NOT NULL",
          "updated": "TEXT NOT NULL",
          "pomoSequence": "TEXT NOT NULL",
        },
      );
}
