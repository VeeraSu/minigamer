enum GameLevel {
  cadet(
    label: 'CADET',
    description: 'A relaxed launch',
    duration: 45,
    spawnInterval: 800,
    minSpeed: 0.003,
    maxSpeed: 0.006,
  ),
  pilot(
    label: 'PILOT',
    description: 'The standard mission',
    duration: 45,
    spawnInterval: 700,
    minSpeed: 0.004,
    maxSpeed: 0.01,
  ),
  commander(
    label: 'COMMANDER',
    description: 'Fast and unforgiving',
    duration: 60,
    spawnInterval: 520,
    minSpeed: 0.006,
    maxSpeed: 0.014,
  );

  final String label;
  final String description;
  final int duration;
  final int spawnInterval;
  final double minSpeed;
  final double maxSpeed;

  const GameLevel({
    required this.label,
    required this.description,
    required this.duration,
    required this.spawnInterval,
    required this.minSpeed,
    required this.maxSpeed,
  });

  Duration get spawnDuration => Duration(milliseconds: spawnInterval);
}
