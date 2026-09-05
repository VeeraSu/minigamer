import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundFx {
  final AudioPlayer _starPlayer = AudioPlayer();
  final AudioPlayer _fuelPlayer = AudioPlayer();
  final AudioPlayer _hitPlayer = AudioPlayer();
  final AudioPlayer _gameOverPlayer = AudioPlayer();

  Future<void> playStar() async {
    await _play(_starPlayer, 'sounds/star.ogg', _playStarFallback);
  }

  Future<void> playFuel() async {
    await _play(_fuelPlayer, 'sounds/fuel.ogg', _playFuelFallback);
  }

  Future<void> playHit() async {
    await _play(_hitPlayer, 'sounds/hit.mp3', _playHitFallback);
  }

  Future<void> playGameOver() async {
    await _play(_gameOverPlayer, 'sounds/gameover.ogg', _playGameOverFallback);
  }

  Future<void> _playStarFallback() => SystemSound.play(SystemSoundType.click);

  Future<void> _playFuelFallback() => SystemSound.play(SystemSoundType.tick);

  Future<void> _playHitFallback() => SystemSound.play(SystemSoundType.alert);

  Future<void> _playGameOverFallback() =>
      SystemSound.play(SystemSoundType.alert);

  Future<void> _play(
    AudioPlayer player,
    String asset,
    Future<void> Function() fallback,
  ) async {
    try {
      // Reuse each player so repeated actions replace, rather than stack,
      // overlapping effects.
      await player.stop();
      await player.play(AssetSource(asset));
    } catch (_) {
      // System sounds keep feedback available when an asset is unavailable
      // or a platform audio player cannot start.
      try {
        await fallback();
      } catch (_) {}
    }
  }

  void dispose() {
    _starPlayer.dispose();
    _fuelPlayer.dispose();
    _hitPlayer.dispose();
    _gameOverPlayer.dispose();
  }
}
