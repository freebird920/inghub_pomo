import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/inghub_icon_class.dart';
import 'package:inghub_pomo/classes/sqlite_schema_class.dart';
import 'package:uuid/uuid.dart';

class PomoTypeSchema {
  final String uuid;
  final bool isDefault;
  String typeName;
  String? description;
  int iconCodePoint;
  int runningTime; // Flutter에서는 DateTime 사용

  // Uuid 인스턴스 생성
  static const Uuid _uuid = Uuid();

  /// 생성자
  /// - [uuid] UUid
  /// - [typeName]은 필수 파라미터
  /// - [runningTime] 초 단위!
  PomoTypeSchema({
    String? uuid, // uuid는 선택적 파라미터
    required this.typeName,
    required this.runningTime,
    this.description,
    this.iconCodePoint = 0xe046,
    this.isDefault = false,
  }) : uuid = uuid ?? _uuid.v4(); // uuid가 없을 경우 자동 생성

  // 객체를 맵으로 변환
  Map<String, dynamic> get toMap {
    return {
      "uuid": uuid,
      "profileName": typeName,
      "description": description,
      "iconCodePoint": iconCodePoint,
      "runningTime": runningTime, // DateTime을 TEXT로 변환
      "isDefault": isDefault == true ? 1 : 0, // bool을 int로 변환
    };
  }

  // 맵에서 객체로 변환하는 팩토리 메서드 추가
  factory PomoTypeSchema.fromMap(Map<String, dynamic> map) {
    return PomoTypeSchema(
      uuid: map["uuid"],
      typeName: map["profileName"],
      description: map["description"],
      runningTime: map["runningTime"], // int -> 초
      iconCodePoint: map["iconCodePoint"],
      isDefault: map["isDefault"] == 1, // int를 bool로 변환
    );
  }

  // 스키마 생성용 SQL 타입 맵
  static SqliteSchema get schema => SqliteSchema(
        tableName: "pomoTypes",
        fields: {
          "uuid": "TEXT PRIMARY KEY",
          "profileName": "TEXT NOT NULL",
          "runningTime": "INTEGER NOT NULL",
          "description": "TEXT",
          "iconCodePoint": "INTEGER NOT NULL",
          "isDefault": "INTEGER",
        },
      );

  static List<PomoTypeSchema> get defaultPomoTypes => [
        PomoTypeSchema(
          uuid: const Uuid().v4(),
          typeName: "집중",
          runningTime: 60 * 25,
          description: "25분 집중 후 5분 휴식",
          iconCodePoint:
              InghubIconClass.fromIcon(const Icon(Icons.hardware)).codePoint,
          isDefault: true,
        ),
        PomoTypeSchema(
          uuid: const Uuid().v4(),
          typeName: "잠깐 휴식",
          runningTime: 60 * 5,
          description: "5분 휴식",
          iconCodePoint:
              InghubIconClass.fromIcon(const Icon(Icons.coffee)).codePoint,
          isDefault: true,
        ),
        PomoTypeSchema(
          uuid: const Uuid().v4(),
          typeName: "긴 휴식",
          runningTime: 60 * 30,
          description: "30분 휴식",
          iconCodePoint:
              InghubIconClass.fromIcon(const Icon(Icons.bed_outlined))
                  .codePoint,
          isDefault: true,
        ),
      ];
}
