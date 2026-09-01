import 'package:flutter/material.dart';

import 'core/presentation/app_home.dart';

class RocketAvoidApp extends StatelessWidget {
  const RocketAvoidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MINI GAMER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C6BC0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101A2B),
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
      ),
      home: const AppHome(),
    );
  }
}
