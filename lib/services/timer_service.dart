import 'dart:async';

class TimerService {
  TimerService._privateConstructor();
  static final TimerService _instance = TimerService._privateConstructor();
  factory TimerService() => _instance;

  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;

  bool get isRunning => _isRunning;
  Duration get duration => _duration;

  // 타이머 초기화
  void init(Duration initialDuration) {
    _duration = initialDuration;
  }

  // 타이머 시작
  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds <= 0) {
        stop();
      } else {
        _duration -= const Duration(seconds: 1);
      }
    });
  }

  // 타이머 일시 정지
  void pause() {
    if (_isRunning && _timer != null) {
      _timer?.cancel();
      _isRunning = false;
    }
  }

  // 타이머 중지 및 초기화
  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _duration = Duration.zero;
  }

  // 타이머 재설정
  void reset(Duration newDuration) {
    stop();
    init(newDuration);
  }
}
