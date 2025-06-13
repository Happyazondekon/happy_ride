import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class CarWidget extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final bool isPlayer;
  final String? customImagePath; // Nouveau paramètre pour l'image personnalisée

  const CarWidget({
    super.key,
    this.color = GameConstants.primaryColor,
    this.width = GameConstants.carWidth,
    this.height = GameConstants.carHeight,
    this.isPlayer = true,
    this.customImagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Déterminer le chemin de l'image à utiliser
    String imagePath = customImagePath ?? _getDefaultImagePath();

    return Container(
      width: width.toScreenWidth(context),
      height: height.toScreenHeight(context),
      child: Stack(
        children: [
          // Image principale de la voiture
          Container(

            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: width.toScreenWidth(context),
                height: height.toScreenHeight(context),
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  // Widget de fallback si l'image ne charge pas
                  return _buildFallbackCar();
                },
              ),
            ),
          ),



        ],
      ),
    );
  }

  String _getDefaultImagePath() {
    if (isPlayer) {
      return 'assets/images/cars/player_car.png';
    } else {
      return 'assets/images/cars/enemy_car.png';
    }
  }

  Widget _buildFallbackCar() {
    // Widget de secours en cas d'erreur de chargement d'image
    return Container(
      width: width,
      height: height,
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

    );
  }
}