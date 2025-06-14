import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class HudWidget extends StatelessWidget {
  const HudWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: GameConstants.defaultPadding,
      left: GameConstants.defaultPadding,
      right: GameConstants.defaultPadding,
      child: Consumer<GameService>(
        builder: (context, gameService, child) {
          final state = gameService.state;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoContainer(
                'Score: ${state.score.formatScore()}',
                context,
              ),
              _buildInfoContainer(
                'Lives: ${state.lives}',
                context,
              ),
              _buildInfoContainer(
                'Level: ${state.level}',
                context,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoContainer(String text, BuildContext context, {Color color = Colors.grey}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(GameConstants.borderRadius),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: GameConstants.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}