import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InghubIconClass {
  final Icon _icon;

  // 사용 가능한 아이콘을 미리 정의
  static final List<Icon> allowedIcons = [
    const Icon(Icons.coffee),
    const Icon(Icons.timer),
    const Icon(Icons.alarm),
    const Icon(Icons.bed_outlined),
    const Icon(Icons.android_outlined),
    const Icon(Icons.hardware),
    const Icon(Icons.headset),
    const Icon(Icons.laptop),
    const Icon(Icons.face),
    const Icon(CupertinoIcons.moon_stars_fill),

    // 원하는 아이콘을 추가하면 됨
  ];

  // 프라이빗 생성자
  InghubIconClass._(this._icon);

  // Icon으로부터 인스턴스 생성하는 factory 메서드
  factory InghubIconClass.fromIcon(Icon icon) {
    // allowedIcons에 있는지 검증하고 반환
    final Icon allowedIcon = allowedIcons.firstWhere(
      (Icon allowed) => allowed.icon!.codePoint == icon.icon!.codePoint,
      orElse: () => const Icon(Icons.android_outlined),
    );

    // 검증된 아이콘으로 인스턴스 생성
    return InghubIconClass._(allowedIcon);
  }

  // codePoint로부터 인스턴스 생성하는 factory 메서드
  factory InghubIconClass.fromCodePoint(int codePoint) {
    // allowedIcons에 있는지 검증하고 반환
    final allowedIcon = allowedIcons.firstWhere(
      (allowed) {
        final iconData = allowed.icon as IconData;
        return iconData.codePoint == codePoint;
      },
      orElse: () => const Icon(Icons.android_outlined),
    );

    // 검증된 아이콘으로 인스턴스 생성
    return InghubIconClass._(allowedIcon);
  }

  // Icon을 반환하는 getter
  Icon get icon => _icon;

  // codePoint를 반환하는 getter
  int get codePoint {
    final iconData = _icon.icon as IconData;
    return iconData.codePoint;
  }
}
