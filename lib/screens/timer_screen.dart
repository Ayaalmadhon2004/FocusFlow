import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildTimerCircle(timerState),
                const SizedBox(height: 24),
                Text(
                  timerState.statusText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                if (timerState.status == TimerStatus.idle)
                  _buildTaskInput(timerNotifier),
                if (timerState.status != TimerStatus.idle && timerState.taskName.isNotEmpty)
                  _buildCurrentTask(timerState.taskName),
                const SizedBox(height: 32),
                _buildControls(timerState, timerNotifier),
                const SizedBox(height: 40),
                _buildTodayStats(timerState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'حافز التركيز',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'ركز على هدفك',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.psychology_outlined,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerCircle(TimerState timerState) {
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
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 8,
              color: AppColors.border,
            ),
          ),
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

  Widget _buildTaskInput(TimerNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _taskController,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          hintText: 'ماذا ستعمل في هذه الجلسة؟',
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(
            Icons.edit_note_outlined,
            color: AppColors.textMuted,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            notifier.start(taskName: value.trim());
          }
        },
      ),
    );
  }

  Widget _buildCurrentTask(String taskName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.task_alt,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            taskName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(TimerState timerState, TimerNotifier notifier) {
    final isRunning = timerState.status == TimerStatus.running;
    final isIdle = timerState.status == TimerStatus.idle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isIdle)
          _ControlButton(
            icon: Icons.refresh_rounded,
            onTap: notifier.reset,
            color: AppColors.textSecondary,
          ),
        if (!isIdle) const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            if (isRunning) {
              notifier.pause();
            } else if (isIdle) {
              final task = _taskController.text.trim();
              notifier.start(taskName: task);
            } else {
              notifier.start();
            }
          },
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
        ),
        if (!isIdle) const SizedBox(width: 20),
        if (!isIdle)
          _ControlButton(
            icon: Icons.stop_rounded,
            onTap: notifier.stop,
            color: AppColors.error,
          ),
      ],
    );
  }

  Widget _buildTodayStats(TimerState timerState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: '${timerState.todaySessionsCount}',
            label: 'جلسات اليوم',
            icon: Icons.local_fire_department_outlined,
            color: AppColors.warning,
          ),
          _StatItem(
            value: '${timerState.totalFocusMinutes}د',
            label: 'وقت التركيز',
            icon: Icons.timer_outlined,
            color: AppColors.primary,
          ),
          _StatItem(
            value: '${timerState.totalSessions}',
            label: 'إجمالي الجلسات',
            icon: Icons.emoji_events_outlined,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}