import 'package:flutter/material.dart';

import 'app.dart';

export 'app.dart';
export 'features/game/domain/game_item.dart';
export 'features/game/domain/game_level.dart';
export 'features/game/presentation/rocket_avoid_game_screen.dart';
export 'features/menu/presentation/main_menu_screen.dart';

void main() {
  runApp(const RocketAvoidApp());
}
