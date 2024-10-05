import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;

  Duration get currentDuration => _duration;
  bool get isRunning => _isRunning;

  void start({required Duration totalDuration}) {
    if (_isRunning) return;

    _duration = totalDuration;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds <= 0) {
        stop();
      } else {
        _duration -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    stop();
    _duration = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
