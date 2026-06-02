import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MovanaApp());
}

class MovanaApp extends StatelessWidget {
  const MovanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movana',
      debugShowCheckedModeBanner: false,
      theme: MovanaTheme.light,
      home: const SplashScreen(),
    );
  }
}
