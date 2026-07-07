import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';
import '../core/constants/app_colors.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 🔥 شريط علوي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FocusFlow 🧭',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  // زر الإحصائيات (نضيفه لاحقاً)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bar_chart, color: AppColors.textSecondary),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // ⏱️ دائرة المؤقت
              SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // الخلفية
                    CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 12,
                      color: AppColors.bgCard,
                    ),
                    // التقدم
                    CircularProgressIndicator(
                      value: timerState.progress,
                      strokeWidth: 12,
                      color: timerState.isRunning 
                          ? AppColors.accentSuccess 
                          : AppColors.accentPrimary,
                      backgroundColor: AppColors.bgCard,
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
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timerState.isRunning 
                              ? 'جاري التركيز... 🍅'
                              : timerState.isPaused
                                  ? 'متوقف مؤقتاً ⏸️'
                                  : 'جاهز للبدء؟',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 📝 إدخال اسم المهمة
              if (!timerState.isRunning)
                TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: '📝 ماذا ستعمل في هذه الجلسة؟',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.bgCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      timerNotifier.start(taskName: value);
                    }
                  },
                ),
              
              if (timerState.isRunning && timerState.taskName.isNotEmpty)
                Text(
                  'تعمل على: ${timerState.taskName}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.accentSecondary,
                  ),
                ),
              
              const SizedBox(height: 30),
              
              // 🎮 أزرار التحكم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // زر إعادة التعيين
                  if (timerState.isRunning || timerState.isPaused)
                    _ControlButton(
                      icon: Icons.refresh,
                      onTap: timerNotifier.reset,
                    ),
                  
                  const SizedBox(width: 20),
                  
                  // زر البدء/الإيقاف المؤقت
                  _PlayButton(
                    isRunning: timerState.isRunning,
                    onTap: () {
                      if (timerState.isRunning) {
                        timerNotifier.pause();
                      } else {
                        timerNotifier.start();
                      }
                    },
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // زر الإيقاف
                  if (timerState.isRunning || timerState.isPaused)
                    _ControlButton(
                      icon: Icons.stop,
                      onTap: timerNotifier.stop,
                    ),
                ],
              ),
              
              const Spacer(),
              
              // 📊 إحصائيات سريعة
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(value: '0', label: 'جلسات', color: AppColors.accentSuccess),
                    _StatItem(value: '0m', label: 'وقت التركيز', color: AppColors.accentPrimary),
                    _StatItem(value: '0%', label: 'التركيز', color: AppColors.accentWarm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// زر التحكم الصغير
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 24),
      ),
    );
  }
}

// زر البدء/الإيقاف الرئيسي
class _PlayButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onTap;

  const _PlayButton({required this.isRunning, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accentPrimary, AppColors.accentSecondary],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentPrimary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          isRunning ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}

// عنصر إحصائي
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
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