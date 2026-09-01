enum ItemType { star, fuel, asteroid }

class GameItem {
  final ItemType type;
  double x;
  double y;
  double speed;

  GameItem({
    required this.type,
    required this.x,
    required this.y,
    required this.speed,
  });
}
