import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../game/domain/game_level.dart';

class BalloonPopScreen extends StatefulWidget {
  final String gameName;
  final GameLevel? initialLevel;

  const BalloonPopScreen({
    super.key,
    this.gameName = 'Balloon Pop',
    this.initialLevel,
  });

  @override
  State<BalloonPopScreen> createState() => _BalloonPopScreenState();
}

class _BalloonPopScreenState extends State<BalloonPopScreen> {
  static const int _totalSeconds = 30;

  final Random _random = Random();
  final List<_Balloon> _balloons = [];

  Timer? _spawnTimer;
  Timer? _driftTimer;
  Timer? _countdownTimer;

  int _score = 0;
  int _timeLeft = _totalSeconds;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _balloons.clear();
    _score = 0;
    _timeLeft = _totalSeconds;
    _isPlaying = true;

    _spawnTimer?.cancel();
    _driftTimer?.cancel();
    _countdownTimer?.cancel();

    // MediaQuery is available after the first frame, so the opening balloon
    // appears immediately without reading inherited data during initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isPlaying) return;
      _spawnBalloon();
    });
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!_isPlaying || !mounted) return;
      _spawnBalloon();
    });

    _driftTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!_isPlaying || !mounted) return;
      setState(() {
        final width = MediaQuery.sizeOf(context).width;
        final height = MediaQuery.sizeOf(context).height;

        // Balloons can leave the screen during this pass; iterate over a copy
        // so removing them does not mutate the active iterator.
        for (final balloon in List<_Balloon>.of(_balloons)) {
          balloon.y += balloon.speed;
          balloon.rotation += balloon.spin;

          if (balloon.y > height - 90 ||
              balloon.x < -30 ||
              balloon.x > width - 30) {
            balloon.x = (balloon.x + balloon.drift).clamp(-10, width - 60);
          }

          if (balloon.y > height + 60) {
            _balloons.remove(balloon);
          }
        }
      });
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPlaying || !mounted) return;
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _timeLeft = 0;
          _finishGame();
        }
      });
    });
  }

  void _spawnBalloon() {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isGolden = _random.nextDouble() < 0.12;
    final color = isGolden
        ? _BalloonColor.gold
        : _BalloonColor
            .values[_random.nextInt(_BalloonColor.values.length - 1)];

    if (_balloons.length >= 12) {
      // Keep rendering and hit testing bounded as balloons continue spawning.
      _balloons.removeAt(0);
    }

    _balloons.add(
      _Balloon(
        id: DateTime.now().microsecondsSinceEpoch + _random.nextInt(10000),
        x: _random.nextDouble() * (width - 80),
        y: -50 - _random.nextDouble() * height * 0.3,
        size: 42 + _random.nextDouble() * 22,
        color: color,
        speed: 2.0 + _random.nextDouble() * 2.0,
        drift: (_random.nextDouble() - 0.5) * 2.2,
        spin: (_random.nextDouble() - 0.5) * 0.06,
      )..isGolden = isGolden,
    );
  }

  void _popBalloon(_Balloon balloon) {
    if (!_isPlaying) return;

    final points = balloon.isGolden ? 20 : balloon.color.points;
    _score += points;
    _balloons.removeWhere((item) => item.id == balloon.id);
    SystemSound.play(SystemSoundType.click);
    setState(() {});
  }

  void _finishGame() {
    _isPlaying = false;
    _spawnTimer?.cancel();
    _driftTimer?.cancel();
    _countdownTimer?.cancel();
    final stars = _score >= 120
        ? 3
        : _score >= 60
            ? 2
            : 1;

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF101A2B),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'PARTY COMPLETE!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score: $_score',
              style: const TextStyle(
                color: Color(0xFFB8C7D9),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Icon(
                  index < stars
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: index < stars
                      ? const Color(0xFFFFC857)
                      : const Color(0xFF53657A),
                  size: 34,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('MAIN MENU'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFC857),
              foregroundColor: const Color(0xFF101A2B),
            ),
            child: const Text('PLAY AGAIN'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _driftTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 400;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: isCompact ? 12 : 16,
        title: Row(
          children: [
            const Icon(Icons.celebration_rounded,
                color: Color(0xFFFFC857), size: 23),
            if (!isCompact) ...[
              const SizedBox(width: 8),
              Text(
                widget.gameName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: _confirmExit,
            tooltip: 'Exit to main menu',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 4 : 10),
            child: _StatusChip(
              icon: Icons.timer_outlined,
              label: '$_timeLeft s',
              color: const Color(0xFFFF8A65),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: isCompact ? 8 : 12),
            child: _StatusChip(
              icon: Icons.star_rounded,
              label: '$_score',
              color: const Color(0xFFFFC857),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF18314F),
              Color(0xFF2E5D7A),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _CloudPainter(),
              ),
            ),
            ..._balloons.map((balloon) {
              return Positioned(
                left: balloon.x,
                top: balloon.y,
                child: GestureDetector(
                  onTap: () => _popBalloon(balloon),
                  child: Transform.rotate(
                    angle: balloon.rotation,
                    child: SizedBox(
                      width: balloon.size + 18,
                      height: balloon.size + 38,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 12,
                            child: Container(
                              width: balloon.size,
                              height: balloon.size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: balloon.isGolden
                                      ? const [
                                          Color(0xFFFFE082),
                                          Color(0xFFFFC857)
                                        ]
                                      : balloon.color.gradient,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: balloon.isGolden
                                        ? const Color(0x44FFC857)
                                        : balloon.color.shadow,
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Icon(
                                    balloon.isGolden
                                        ? Icons.auto_awesome_rounded
                                        : Icons.celebration_rounded,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: balloon.isGolden ? 18 : 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 2,
                              height: 36,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app_rounded,
                        color: Color(0xFFFFC857), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap balloons before they float away!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF101A2B),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'EXIT MISSION?',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: const Text(
          'Your current score will not be saved.',
          style: TextStyle(color: Color(0xFFB8C7D9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFC857),
              foregroundColor: const Color(0xFF101A2B),
            ),
            child: const Text('EXIT'),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      Navigator.pop(context);
    }
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.08);

    for (int i = 0; i < 8; i++) {
      final offset = i * 90.0;
      final cloudRect = Rect.fromLTWH(
          offset % (size.width + 30), (i % 3) * 90.0 + 20, 110, 36);
      canvas.drawRRect(
        RRect.fromRectAndRadius(cloudRect, const Radius.circular(18)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Balloon {
  final int id;
  double x;
  double y;
  final double size;
  final _BalloonColor color;
  final double speed;
  final double drift;
  final double spin;
  bool isGolden = false;
  double rotation = 0;

  _Balloon({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.drift,
    required this.spin,
  });
}

enum _BalloonColor {
  pink(
      gradient: [Color(0xFFFC7ECA), Color(0xFFFF4FA3)],
      shadow: Color(0x66FF4FA3),
      points: 5),
  blue(
      gradient: [Color(0xFF7DE2D1), Color(0xFF2CC9D4)],
      shadow: Color(0x662CC9D4),
      points: 8),
  yellow(
      gradient: [Color(0xFFFFE082), Color(0xFFFFC857)],
      shadow: Color(0x66FFC857),
      points: 10),
  green(
      gradient: [Color(0xFF9BE15D), Color(0xFF56C596)],
      shadow: Color(0x6656C596),
      points: 12),
  gold(
      gradient: [Color(0xFFFFE082), Color(0xFFFFC857)],
      shadow: Color(0x99FFC857),
      points: 20);

  const _BalloonColor({
    required this.gradient,
    required this.shadow,
    required this.points,
  });

  final List<Color> gradient;
  final Color shadow;
  final int points;
}
