import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/timer_provider.dart';
import '../widgets/timer_header.dart';
import '../widgets/timer_circle.dart';
import '../widgets/task_input.dart';
import '../widgets/current_task.dart';
import '../widgets/control_buttons.dart';
import '../widgets/stats_card.dart';

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
                const TimerHeader(),
                const SizedBox(height: 32),
                TimerCircle(timerState: timerState),
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
                  TaskInput(
                    controller: _taskController,
                    notifier: timerNotifier,
                  ),
                if (timerState.status != TimerStatus.idle && timerState.taskName.isNotEmpty)
                  CurrentTask(taskName: timerState.taskName),
                const SizedBox(height: 32),
                ControlButtons(
                  timerState: timerState,
                  notifier: timerNotifier,
                  taskController: _taskController,
                ),
                const SizedBox(height: 40),
                StatsCard(timerState: timerState),
              ],
            ),
          ),
        ),
      ),
    );
  }
}