import 'package:elimapass/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0XFF223E68),
);
var darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0XFF223E68),
  brightness: Brightness.dark,
  surface: const Color.fromARGB(255, 31, 31, 44),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eLimaPass',
      theme: ThemeData(
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
      ).copyWith(
        scaffoldBackgroundColor: darkColorScheme.surface,
      ),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
