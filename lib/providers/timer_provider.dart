import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimerStatus { idle, running, paused, completed }

class TimerState {
  final int remainingSeconds;
  final TimerStatus status;
  final String taskName;
  final int totalSessions;
  final int totalFocusMinutes;
  final int todaySessionsCount;

  const TimerState({
    this.remainingSeconds = 1500,
    this.status = TimerStatus.idle,
    this.taskName = '',
    this.totalSessions = 0,
    this.totalFocusMinutes = 0,
    this.todaySessionsCount = 0,
  });

  TimerState copyWith({
    int? remainingSeconds,
    TimerStatus? status,
    String? taskName,
    int? totalSessions,
    int? totalFocusMinutes,
    int? todaySessionsCount,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      taskName: taskName ?? this.taskName,
      totalSessions: totalSessions ?? this.totalSessions,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      todaySessionsCount: todaySessionsCount ?? this.todaySessionsCount,
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress => remainingSeconds / 1500;
  
  String get statusText {
    switch (status) {
      case TimerStatus.idle:
        return 'جاهز للبدء';
      case TimerStatus.running:
        return 'جاري التركيز...';
      case TimerStatus.paused:
        return 'متوقف مؤقتاً';
      case TimerStatus.completed:
        return 'اكتملت الجلسة! 🎉';
    }
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(const TimerState());

  Timer? _timer;
  int _sessionCount = 0;
  int _totalMinutes = 0;

  void start({String taskName = ''}) {
    if (state.status == TimerStatus.idle) {
      state = state.copyWith(
        remainingSeconds: 1500,
        status: TimerStatus.running,
        taskName: taskName,
      );
    } else if (state.status == TimerStatus.paused) {
      state = state.copyWith(status: TimerStatus.running);
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _completeSession();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void reset() {
    _timer?.cancel();
    state = const TimerState(
      totalSessions: 0,
      totalFocusMinutes: 0,
      todaySessionsCount: 0,
    );
  }

  void stop() {
    _timer?.cancel();
    state = TimerState(  // ✅ شلت const
      totalSessions: _sessionCount,
      totalFocusMinutes: _totalMinutes,
      todaySessionsCount: _sessionCount,
    );
  }

  void _completeSession() {
    _timer?.cancel();
    _sessionCount++;
    _totalMinutes += 25;
    
    state = state.copyWith(
      status: TimerStatus.completed,
      totalSessions: _sessionCount,
      totalFocusMinutes: _totalMinutes,
      todaySessionsCount: _sessionCount,
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        state = state.copyWith(
          status: TimerStatus.idle,
          remainingSeconds: 1500,
          taskName: '',
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}