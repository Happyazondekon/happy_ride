import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class CarWidget extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final bool isPlayer;

  const CarWidget({
    super.key,
    this.color = GameConstants.primaryColor,
    this.width = GameConstants.carWidth,
    this.height = GameConstants.carHeight,
    this.isPlayer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toScreenWidth(context),
      height: height.toScreenHeight(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.9),
            color,
            color.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Carrosserie principale
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: color,
              border: Border.all(color: Colors.black26, width: 1),
            ),
          ),
          // Pare-brise
          Positioned(
            top: 4,
            left: 4,
            right: 4,
            height: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                color: Colors.lightBlue.withOpacity(0.3),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
            ),
          ),
          // Pare-brise arrière
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            height: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                color: Colors.lightBlue.withOpacity(0.2),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
            ),
          ),
          // Phares avant (pour la voiture du joueur)
          if (isPlayer) ...[
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
          // Feux arrière (pour les voitures ennemies)
          if (!isPlayer) ...[
            Positioned(
              bottom: 2,
              left: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
          // Bande décorative
          Center(
            child: Container(
              width: width.toScreenWidth(context) * 0.8,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}