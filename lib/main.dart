import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/timer_provider.dart';
import 'core/constants/app_colors.dart'; // لا تنسي استيراد ملف الألوان

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // هنا نضع الثيم داخل MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgDark,
        primaryColor: AppColors.accentPrimary,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      home: const TimerScreen(),
    );
  }
}

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timerProvider);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${(time ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 48, 
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary, // استخدمنا اللون من الثيم
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(timerProvider.notifier).start(),
              child: const Text("Start Timer"),
            ),
          ],
        ),
      ),
    );
  }
}