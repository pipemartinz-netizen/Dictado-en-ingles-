import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DictadoInglesApp());
}

class DictadoInglesApp extends StatelessWidget {
  const DictadoInglesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictado Inglés',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3D5AFE),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3D5AFE),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
