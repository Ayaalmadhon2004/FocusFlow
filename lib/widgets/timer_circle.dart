import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../providers/timer_provider.dart';

class TimerCircle extends StatelessWidget {
  final TimerState timerState;

  const TimerCircle({super.key, required this.timerState});

  @override
  Widget build(BuildContext context) {
    final isRunning = timerState.status == TimerStatus.running;
    final isCompleted = timerState.status == TimerStatus.completed;

    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الدائرة الخلفية
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 8,
              color: AppColors.border,
            ),
          ),
          // دائرة التقدم المتحركة
          SizedBox(
            width: 240,
            height: 240,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: timerState.progress),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  color: isCompleted
                      ? AppColors.success
                      : isRunning
                          ? AppColors.primary
                          : AppColors.accent,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
          ),
          // الوقت
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timerState.formattedTime,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'دقيقة',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}