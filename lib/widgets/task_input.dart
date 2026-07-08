import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../providers/timer_provider.dart';

class TaskInput extends StatelessWidget {
  final TextEditingController controller;
  final TimerNotifier notifier;

  const TaskInput({
    super.key,
    required this.controller,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
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
        controller: controller,
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
}