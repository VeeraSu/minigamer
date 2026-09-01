import 'package:flutter/material.dart';

import '../../game/application/game_catalog.dart';
import '../../game/domain/game_definition.dart';
import '../../game/domain/game_level.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final List<GameDefinition> _games = GameCatalog.games;

  late GameDefinition _selectedGame = _games.first;
  GameLevel _selectedDifficulty = GameLevel.pilot;

  @override
  Widget build(BuildContext context) {
    final supportsDifficulty = _selectedGame.supportsDifficulty;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.apps_rounded, color: Color(0xFFFFC857), size: 24),
            SizedBox(width: 10),
            Text(
              'MINI GAMES',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF101A2B),
              Color(0xFF172A46),
              Color(0xFF253D5B),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose your game',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Pick an experience and launch into a fresh mission.',
                            style: TextStyle(
                              color: Color(0xFFB8C7D9),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _games.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final game = _games[index];
                        final isSelected = _selectedGame.id == game.id;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => setState(() => _selectedGame = game),
                            borderRadius: BorderRadius.circular(18),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? game.accent.withValues(alpha: 0.12)
                                    : Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected
                                      ? game.accent.withValues(alpha: 0.85)
                                      : Colors.white.withValues(alpha: 0.1),
                                  width: isSelected ? 1.6 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color:
                                          game.accent.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      game.icon,
                                      color: game.accent,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          game.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          game.category,
                                          style: const TextStyle(
                                            color: Color(0xFFFFC857),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          game.description,
                                          style: const TextStyle(
                                            color: Color(0xFFB8C7D9),
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: game.accent,
                                      size: 26,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (supportsDifficulty) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Difficulty',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<GameLevel>(
                              initialValue: _selectedDifficulty,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.04),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.18),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFFC857),
                                    width: 1.3,
                                  ),
                                ),
                              ),
                              dropdownColor: const Color(0xFF172A46),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              iconEnabledColor: const Color(0xFFFFC857),
                              items: GameLevel.values.map((level) {
                                return DropdownMenuItem<GameLevel>(
                                  value: level,
                                  child: Text(
                                    level.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (GameLevel? value) {
                                if (value != null) {
                                  setState(() => _selectedDifficulty = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameCatalog.buildScreen(
                                definition: _selectedGame,
                                difficulty: _selectedDifficulty,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: const Text('Launch Selected App'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC857),
                          foregroundColor: const Color(0xFF101A2B),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => HowToPlayDialog(
                              gameName: _selectedGame.name,
                            ),
                          );
                        },
                        icon: const Icon(Icons.help_outline_rounded, size: 18),
                        label: const Text('How to Play'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFB8C7D9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HowToPlayDialog extends StatelessWidget {
  final String gameName;

  const HowToPlayDialog({
    super.key,
    required this.gameName,
  });

  @override
  Widget build(BuildContext context) {
    final isBalloonGame = gameName == 'Balloon Pop Party';
    final rows = isBalloonGame
        ? [
            const _BriefingRow(
              icon: Icons.touch_app_rounded,
              color: Color(0xFF7DE2D1),
              title: 'Tap balloons',
              detail: 'Pop each balloon before it drifts away.',
            ),
            const SizedBox(height: 14),
            const _BriefingRow(
              icon: Icons.star_rounded,
              color: Color(0xFFFFC857),
              title: 'Score points',
              detail: 'Different colors give different rewards.',
            ),
            const SizedBox(height: 14),
            const _BriefingRow(
              icon: Icons.auto_awesome_rounded,
              color: Color(0xFF7DE2D1),
              title: 'Golden balloons',
              detail: 'Rare gold balloons award bonus points.',
            ),
            const SizedBox(height: 14),
            const _BriefingRow(
              icon: Icons.timer_rounded,
              color: Color(0xFFFF8A65),
              title: 'Beat the clock',
              detail: 'Keep tapping until the timer hits zero.',
            ),
            const SizedBox(height: 8),
          ]
        : [
            const _BriefingRow(
              icon: Icons.swipe_rounded,
              color: Color(0xFF7DE2D1),
              title: 'Steer your rocket',
              detail: 'Drag left and right to navigate.',
            ),
            const SizedBox(height: 14),
            const _BriefingRow(
              icon: Icons.star_rounded,
              color: Color(0xFFFFC857),
              title: 'Collect stars',
              detail: 'Every star adds 1 point.',
            ),
            const SizedBox(height: 14),
            const _BriefingRow(
              icon: Icons.battery_full_rounded,
              color: Color(0xFF7DE2D1),
              title: 'Catch fuel',
              detail: 'Fuel canisters add 2 points.',
            ),
            const SizedBox(height: 14),
            const _BriefingRow(
              icon: Icons.warning_amber_rounded,
              color: Color(0xFFFF8A65),
              title: 'Avoid asteroids',
              detail: 'You have 45 seconds to set a high score.',
            ),
            const SizedBox(height: 8),
          ];

    return AlertDialog(
      backgroundColor: const Color(0xFF111B2E),
      surfaceTintColor: Colors.transparent,
      elevation: 20,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(
          color: Color(0xFFFFC857),
          width: 0.5,
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      title: Row(
        children: [
          const Icon(Icons.flag_rounded, color: Color(0xFFFFC857), size: 25),
          const SizedBox(width: 10),
          Text(
            isBalloonGame ? 'BALLOON PARTY' : 'MISSION BRIEFING',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFC857),
            foregroundColor: const Color(0xFF101A2B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('GOT IT'),
        ),
      ],
    );
  }
}

class _BriefingRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String detail;

  const _BriefingRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  color: Color(0xFFB8C7D9),
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
