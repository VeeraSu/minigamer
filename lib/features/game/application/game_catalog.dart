import 'package:flutter/material.dart';

import '../domain/game_definition.dart';
import '../domain/game_level.dart';
import '../presentation/balloon_pop_screen.dart';
import '../presentation/rocket_avoid_game_screen.dart';

class GameCatalog {
  static const List<GameDefinition> games = [
    GameDefinition(
      id: 'mini_gamer',
      name: 'MINI GAMER',
      category: 'Arcade Action',
      description: 'Dodge asteroids, collect stars, and survive the launch.',
      accent: Color(0xFFFFC857),
      icon: Icons.rocket_launch_rounded,
      supportsDifficulty: true,
    ),
    GameDefinition(
      id: 'balloon_pop_party',
      name: 'Balloon Pop Party',
      category: 'Casual Fun',
      description:
          'Tap colorful balloons before they disappear and chase a high score.',
      accent: Color(0xFF7DE2D1),
      icon: Icons.celebration_rounded,
    ),
  ];

  static GameDefinition getById(String id) {
    return games.firstWhere((game) => game.id == id, orElse: () => games.first);
  }

  static Widget buildScreen({
    required GameDefinition definition,
    required GameLevel difficulty,
  }) {
    switch (definition.id) {
      case 'mini_gamer':
        return GameScreen(gameName: definition.name, initialLevel: difficulty);
      case 'balloon_pop_party':
        return BalloonPopScreen(
          gameName: definition.name,
          initialLevel: difficulty,
        );
      default:
        return GameScreen(gameName: definition.name, initialLevel: difficulty);
    }
  }
}
