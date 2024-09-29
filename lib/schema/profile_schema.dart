import 'package:flutter/foundation.dart' show immutable;

//  TEXT 형식의 ISO 8601 확장 (YYYY-MM-DD HH:MM:SS.SSS)이야.
//  이것은 SQLite에서 DATETIME 형식으로 저장됩니다.

@immutable
class ProfileSchema {
  final String uuid;
  final String profileName;
  final String description;
  final String created;
  final int phoneNumber;

  const ProfileSchema({
    required this.uuid,
    required this.profileName,
    required this.description,
    required this.created,
    required this.phoneNumber,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": uuid,
      "name": profileName,
      "email": description,
      "password": created,
      "phoneNumber": phoneNumber,
    };
  }
}
