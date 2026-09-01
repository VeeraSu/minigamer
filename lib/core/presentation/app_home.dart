import 'package:flutter/material.dart';

import '../../features/menu/presentation/main_menu_screen.dart';
import 'enhanced_splash_screen.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? EnhancedSplashScreen(
            displayDuration: const Duration(seconds: 3),
            onComplete: _onSplashComplete,
            customIconPath: 'assets/images/app_icon.png',
            appTitle: 'MINI GAMER',
            appSubtitle: 'Action. Challenge. Thrill.',
          )
        : const MainMenuScreen();
  }
}
