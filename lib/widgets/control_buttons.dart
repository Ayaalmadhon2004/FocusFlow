import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../providers/timer_provider.dart';

class ControlButtons extends StatelessWidget {
  final TimerState timerState;
  final TimerNotifier notifier;
  final TextEditingController taskController;

  const ControlButtons({
    super.key,
    required this.timerState,
    required this.notifier,
    required this.taskController,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = timerState.status == TimerStatus.running;
    final isIdle = timerState.status == TimerStatus.idle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // زر إعادة التعيين
        if (!isIdle)
          _ControlButton(
            icon: Icons.refresh_rounded,
            onTap: notifier.reset,
            color: AppColors.textSecondary,
          ),
        if (!isIdle) const SizedBox(width: 20),
        
        // زر البدء/الإيقاف الرئيسي
        _PlayPauseButton(
          isRunning: isRunning,
          isIdle: isIdle,
          onTap: () {
            if (isRunning) {
              notifier.pause();
            } else if (isIdle) {
              final task = taskController.text.trim();
              notifier.start(taskName: task);
            } else {
              notifier.start();
            }
          },
        ),
        
        if (!isIdle) const SizedBox(width: 20),
        
        // زر الإيقاف
        if (!isIdle)
          _ControlButton(
            icon: Icons.stop_rounded,
            onTap: notifier.stop,
            color: AppColors.error,
          ),
      ],
    );
  }
}

// زر التحكم الصغير
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

// زر البدء/الإيقاف الرئيسي
class _PlayPauseButton extends StatelessWidget {
  final bool isRunning;
  final bool isIdle;
  final VoidCallback onTap;

  const _PlayPauseButton({
    required this.isRunning,
    required this.isIdle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isRunning
                ? [AppColors.warning, const Color(0xFFFFB74D)]
                : [AppColors.primary, AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isRunning ? AppColors.warning : AppColors.primary)
                  .withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}