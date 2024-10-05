import 'dart:async';

class TimerService {
  TimerService._privateConstructor();
  static final TimerService _instance = TimerService._privateConstructor();
  factory TimerService() => _instance;

  final bool _isInit = false;
  bool get isInit => _isInit;

  Timer? _secondsTimer;

  void init() {
    // 초기화 작업
    _secondsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // 1초마다 실행
    });
  }
}
