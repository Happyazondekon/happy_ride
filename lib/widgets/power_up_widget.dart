import 'package:flutter/material.dart';
import '../models/car.dart';
import '../utils/extensions.dart';

class PowerUpWidget extends StatelessWidget {
  final PowerUp powerUp;

  const PowerUpWidget({super.key, required this.powerUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: powerUp.color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          powerUp.emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}