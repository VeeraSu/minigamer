import 'package:flutter/material.dart';

import 'game_controller.dart';
import '../domain/game_item.dart';
import '../domain/game_level.dart';

class GameScreen extends StatefulWidget {
  final GameLevel? initialLevel;
  final String gameName;

  const GameScreen({
    super.key,
    this.initialLevel,
    this.gameName = 'MINI GAMER',
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  late GameLevel _selectedLevel;
  bool _gameStarted = false;
  static const double rocketBottomPadding = 16;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel ?? GameLevel.pilot;
    _gameStarted = true;
    _startGame();
  }

  void _startGame() {
    _controller = GameController(
      onChanged: _refresh,
      onGameOver: _showGameOver,
      level: _selectedLevel,
    )..start();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _showGameOver(int score, int fuelCaught, int stars) {
    // Let the final movement frame settle before presenting the result modal.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => GameOverDialog(
          gameName: widget.gameName,
          score: score,
          fuelCaught: fuelCaught,
          stars: stars,
          onPlayAgain: () {
            Navigator.pop(context);
            _controller.start();
          },
          onMainMenu: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
    });
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

  @override
  void dispose() {
    if (_gameStarted) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFF101A2B),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC857)),
          ),
        ),
      );
    }

    final isCompact = MediaQuery.sizeOf(context).width < 400;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: isCompact ? 12 : 16,
          title: Row(
            children: [
              const Icon(
                Icons.rocket_launch,
                color: Color(0xFFFFC857),
                size: 23,
              ),
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
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: isCompact ? 4 : 8),
              visualDensity: isCompact
                  ? const VisualDensity(horizontal: -2, vertical: -2)
                  : VisualDensity.standard,
              icon: Icon(
                _controller.isMuted ? Icons.volume_off : Icons.volume_up,
              ),
              onPressed: _controller.toggleMute,
              tooltip: _controller.isMuted ? 'Unmute' : 'Mute',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isCompact ? 3 : 4),
              child: _StatusPill(
                icon: Icons.star_rounded,
                color: Color(0xFFFFC857),
                label: '${_controller.score}',
                compact: isCompact,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isCompact ? 3 : 4),
              child: _StatusPill(
                icon: Icons.battery_full_rounded,
                color: Color(0xFF7DE2D1),
                label: '${_controller.fuelCaught}',
                compact: isCompact,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: isCompact ? 3 : 4, right: 12),
              child: _StatusPill(
                icon: Icons.timer_outlined,
                color: Color(0xFFFF8A65),
                label: '${_controller.timeLeft}s',
                compact: isCompact,
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: ColoredBox(
              color: Color(0x667DE2D1),
              child: SizedBox(height: 1),
            ),
          ),
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) => _controller.moveRocket(
            details.delta.dx,
            MediaQuery.of(context).size.width,
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
                  Color(0xFF415A77),
                ],
              ),
            ),
            child: Stack(
              children: [
                ..._controller.items.map(
                  (item) => Positioned(
                    left: item.x * MediaQuery.of(context).size.width,
                    top: item.y * MediaQuery.of(context).size.height,
                    child: Transform.translate(
                      offset: const Offset(-20, -20),
                      child: ItemIcon(item: item),
                    ),
                  ),
                ),
                ValueListenableBuilder<double>(
                  valueListenable: _controller.rocketXNotifier,
                  builder: (context, rocketX, _) => Positioned(
                    left: rocketX * MediaQuery.of(context).size.width,
                    top:
                        GameController.rocketY *
                            MediaQuery.of(context).size.height -
                        rocketBottomPadding,
                    child: Transform.translate(
                      offset: const Offset(-24, -24),
                      child: const _RocketVisual(),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 4,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool compact;

  const _StatusPill({
    required this.icon,
    required this.color,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 9,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 14 : 16, color: color),
          SizedBox(width: compact ? 3 : 5),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemIcon extends StatelessWidget {
  final GameItem item;

  const ItemIcon({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case ItemType.star:
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFC857).withValues(alpha: 0.16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x99FFC857),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.star_rounded,
            size: 28,
            color: Color(0xFFFFD86B),
          ),
        );
      case ItemType.fuel:
        return Container(
          width: 34,
          height: 38,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFB8FFF1), Color(0xFF27BFA9)],
            ),
            border: Border.all(color: const Color(0xFFD9FFF8), width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x777DE2D1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.battery_full_rounded,
            size: 24,
            color: Color(0xFF123448),
          ),
        );
      case ItemType.asteroid:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF907A), Color(0xFFB52F4A)],
            ),
            border: Border.all(color: const Color(0xFFFFB09A), width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x668B203B),
                blurRadius: 8,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.blur_on_rounded,
            size: 22,
            color: Color(0xFF6D1E35),
          ),
        );
    }
  }
}

class _RocketVisual extends StatelessWidget {
  const _RocketVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 12,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFE082), Color(0xFFFF7043)],
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x99FF7043), blurRadius: 10),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.rocket_launch_rounded,
            size: 40,
            color: Colors.white,
            shadows: [Shadow(color: Color(0x997DE2D1), blurRadius: 8)],
          ),
        ],
      ),
    );
  }
}

class GameOverDialog extends StatelessWidget {
  final String gameName;
  final int score;
  final int fuelCaught;
  final int stars;
  final VoidCallback onPlayAgain;
  final VoidCallback onMainMenu;

  const GameOverDialog({
    super.key,
    required this.gameName,
    required this.score,
    required this.fuelCaught,
    required this.stars,
    required this.onPlayAgain,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF101A2B),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: Color(0xFFFFC857),
                size: 25,
              ),
              const SizedBox(width: 10),
              Text(
                gameName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Time's up, pilot!",
            style: TextStyle(color: Color(0xFFB8C7D9), fontSize: 13),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: [
                const Text(
                  'FINAL SCORE',
                  style: TextStyle(
                    color: Color(0xFFB8C7D9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.battery_full_rounded,
                      color: Color(0xFF7DE2D1),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'FUEL COLLECTED: $fuelCaught',
                      style: const TextStyle(
                        color: Color(0xFF7DE2D1),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  index < stars
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: index < stars
                      ? const Color(0xFFFFC857)
                      : const Color(0xFF53657A),
                  size: 38,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'PERFORMANCE RATING',
            style: TextStyle(
              color: Color(0xFF70839A),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
      actions: [
        FilledButton.tonalIcon(
          onPressed: onMainMenu,
          icon: const Icon(Icons.home_outlined, size: 17),
          label: const Text('MAIN MENU'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF253D5B),
            foregroundColor: const Color(0xFFB8C7D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: onPlayAgain,
          icon: const Icon(Icons.replay_rounded, size: 18),
          label: const Text('PLAY AGAIN'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFC857),
            foregroundColor: const Color(0xFF101A2B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
