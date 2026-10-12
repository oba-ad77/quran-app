import 'package:flutter/material.dart';
import 'services/audio_controller.dart';
import 'theme/app_theme.dart';
import 'widgets/mini_player.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioController.initAsync();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:  'خطب العلامة الشيخ محمد الإمام \u0661\u0664\u0664\u0667',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              if (child != null) child,
              const Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: MiniPlayer(),
              ),
            ],
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}