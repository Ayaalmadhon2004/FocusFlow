import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../providers/timer_provider.dart';

class StatsCard extends StatelessWidget {
  final TimerState timerState;

  const StatsCard({super.key, required this.timerState});

  @override
  Widget build(BuildContext context) {
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