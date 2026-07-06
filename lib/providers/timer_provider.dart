import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// هذا الـ Provider هو مثل الـ Global Context في React
final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier() : super(1500); // 1500 ثانية = 25 دقيقة (البومودورو)
  
  Timer? _timer;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) state--;
      else stop();
    });
  }

  void stop() {
    _timer?.cancel();
  }
}