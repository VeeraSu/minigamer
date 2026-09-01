import 'package:flutter/material.dart';

class GameDefinition {
  final String id;
  final String name;
  final String category;
  final String description;
  final Color accent;
  final IconData icon;
  final bool supportsDifficulty;

  const GameDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.accent,
    required this.icon,
    this.supportsDifficulty = false,
  });
}
