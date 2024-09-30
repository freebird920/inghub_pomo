import 'package:inghub_pomo/classes/sqlite_schema_class.dart';

class ProfileSchema {
  final String uuid;
  final String profileName;
  final String description;
  final String? currentPomo;
  final DateTime created; // Flutter에서는 DateTime 사용
  final DateTime updated;

  const ProfileSchema({
    required this.currentPomo,
    required this.uuid,
    required this.profileName,
    required this.description,
    required this.created,
    required this.updated,
  });

  // 객체를 맵으로 변환
  Map<String, dynamic> get toMap {
    return {
      "uuid": uuid,
      "profileName": profileName,
      "description": description,
      "currentPomo": currentPomo,
      "created": created.toIso8601String(), // DateTime을 TEXT로 변환
      "updated": updated.toIso8601String(),
    };
  }

  // 맵에서 객체로 변환하는 팩토리 메서드 추가
  factory ProfileSchema.fromMap(Map<String, dynamic> map) {
    return ProfileSchema(
      uuid: map["uuid"],
      profileName: map["profileName"],
      currentPomo: map["currentPomo"],
      description: map["description"],
      created: DateTime.parse(map["created"]), // TEXT를 DateTime으로 변환
      updated: DateTime.parse(map["updated"]),
    );
  }

  // 스키마 생성용 SQL 타입 맵
  SqliteSchema get schema => SqliteSchema(
        tableName: "profiles",
        fields: {
          "uuid": "TEXT PRIMARY KEY",
          "profileName": "TEXT NOT NULL",
          "description": "TEXT",
          "currentPomo": "TEXT",
          "created": "TEXT NOT NULL",
          "updated": "TEXT NOT NULL",
        },
      );
}
