import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/audio/sound_fx.dart';
import '../domain/game_item.dart';
import '../domain/game_level.dart';

class GameController {
  static const double rocketY = 0.8;

  final GameLevel level;
  final SoundFx _sfx;
  final Random _random;
  final void Function(int score, int fuelCaught, int stars) onGameOver;
  final void Function() onChanged;

  List<GameItem> items = [];
  double rocketX = 0.5;
  final ValueNotifier<double> rocketXNotifier = ValueNotifier(0.5);
  int score = 0;
  int fuelCaught = 0;
  int timeLeft = GameLevel.pilot.duration;
  bool gameActive = false;
  bool gameFinished = false;
  bool isMuted = false;

  Timer? _spawnTimer;
  Timer? _moveTimer;
  Timer? _countdownTimer;

  GameController({
    required this.onGameOver,
    required this.onChanged,
    this.level = GameLevel.pilot,
    SoundFx? sfx,
    Random? random,
  })  : _sfx = sfx ?? SoundFx(),
        _random = random ?? Random();

  void start() {
    // A restart reuses this controller, so every previous timer must stop
    // before the new game state begins.
    _cancelTimers();
    items.clear();
    rocketX = 0.5;
    rocketXNotifier.value = rocketX;
    score = 0;
    fuelCaught = 0;
    timeLeft = level.duration;
    gameActive = true;
    gameFinished = false;
    onChanged();

    _spawnTimer = Timer.periodic(level.spawnDuration, (_) {
      if (gameActive && !gameFinished) _spawnItem();
    });
    _moveTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (gameActive && !gameFinished) _moveItems();
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (gameActive && !gameFinished) _tick();
    });
  }

  void moveRocket(double delta, double screenWidth) {
    if (!gameActive || gameFinished) return;
    rocketX = (rocketX + delta / screenWidth).clamp(0.06, 0.94);
    rocketXNotifier.value = rocketX;
  }

  void toggleMute() {
    isMuted = !isMuted;
    onChanged();
  }

  void _spawnItem() {
    final value = _random.nextDouble();
    final type = value < 0.4
        ? ItemType.star
        : value < 0.6
            ? ItemType.fuel
            : ItemType.asteroid;

    items.add(GameItem(
      type: type,
      x: _random.nextDouble() * 0.8 + 0.1,
      y: 0,
      speed: _random.nextDouble() * (level.maxSpeed - level.minSpeed) +
          level.minSpeed,
    ));
    onChanged();
  }

  void _moveItems() {
    for (final item in items) {
      item.y += item.speed;
    }
    items.removeWhere((item) => item.y > 1.1);
    _checkCollisions();
    onChanged();
  }

  void _checkCollisions() {
    final collected = <GameItem>[];

    for (final item in items) {
      // Positions are normalized to 0..1; these thresholds match the rocket
      // and item hit areas rather than their full visual bounds.
      final dx = (item.x - rocketX).abs();
      final dy = (item.y - rocketY).abs();
      if (dx >= 0.06 || dy >= 0.07) continue;

      switch (item.type) {
        case ItemType.star:
          score += 1;
          if (!isMuted) _sfx.playStar();
        case ItemType.fuel:
          score += 2;
          fuelCaught++;
          if (!isMuted) _sfx.playFuel();
        case ItemType.asteroid:
          score = max(0, score - 1);
          if (!isMuted) _sfx.playHit();
      }
      collected.add(item);
    }
    // Remove after iteration so collision handling never mutates the list
    // being inspected.
    items.removeWhere(collected.contains);
  }

  void _tick() {
    timeLeft--;
    if (timeLeft <= 0) {
      _endGame();
    } else {
      onChanged();
    }
  }

  void _endGame() {
    if (gameFinished) return;
    gameFinished = true;
    gameActive = false;
    _cancelTimers();
    if (!isMuted) _sfx.playGameOver();

    final stars = score >= 25
        ? 3
        : score >= 15
            ? 2
            : score >= 5
                ? 1
                : 0;
    onChanged();
    onGameOver(score, fuelCaught, stars);
  }

  void _cancelTimers() {
    _spawnTimer?.cancel();
    _moveTimer?.cancel();
    _countdownTimer?.cancel();
  }

  void dispose() {
    _cancelTimers();
    _sfx.dispose();
    rocketXNotifier.dispose();
  }
}
