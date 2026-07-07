import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// الحالة الكاملة للمؤقت
class TimerState {
  final int remainingSeconds;
  final bool isRunning;
  final bool isPaused;
  final String taskName;

  const TimerState({
    this.remainingSeconds = 1500, // 25 دقيقة
    this.isRunning = false,
    this.isPaused = false,
    this.taskName = '',
  });

  TimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    bool? isPaused,
    String? taskName,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      taskName: taskName ?? this.taskName,
    );
  }

  // الوقت منسق MM:SS
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // نسبة التقدم (0.0 إلى 1.0)
  double get progress => remainingSeconds / 1500;
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(const TimerState());

  Timer? _timer;

  void start({String taskName = ''}) {
    // إذا كان متوقف، ابدأ من الأول
    if (!state.isRunning && !state.isPaused) {
      state = state.copyWith(
        remainingSeconds: 1500,
        isRunning: true,
        taskName: taskName,
      );
    } 
    // إذا كان متوقف مؤقتاً، استمر
    else if (state.isPaused) {
      state = state.copyWith(isRunning: true, isPaused: false);
    }
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _complete();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  void stop() {
    _timer?.cancel();
    state = const TimerState(); // رجع للبداية
  }

  void reset() {
    _timer?.cancel();
    state = const TimerState();
  }

  void _complete() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, isPaused: false);
    // TODO: حفظ الجلسة في التخزين المحلي
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}