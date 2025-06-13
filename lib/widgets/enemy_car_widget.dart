import 'package:flutter/material.dart';
import '../models/car.dart';
import '../utils/extensions.dart';
import '../utils/constants.dart';

class EnemyCarWidget extends StatelessWidget {
  final EnemyCar enemyCar;

  const EnemyCarWidget({super.key, required this.enemyCar});

  @override
  Widget build(BuildContext context) {
    String imagePath = _getImagePathForCarType(enemyCar.carType);

    return Container(
      width: enemyCar.width.toScreenWidth(context),
      height: enemyCar.height.toScreenHeight(context),
      child: Stack(
        children: [
          // Image principale de la voiture ennemie
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Transform.rotate(
                angle: 3.14159, // Rotation de 180 degrés pour les voitures ennemies
                child: Image.asset(
                  imagePath,
                  width: enemyCar.width.toScreenWidth(context),
                  height: enemyCar.height.toScreenHeight(context),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFallbackEnemyCar();
                  },
                ),
              ),
            ),
          ),

          // Overlay de couleur pour différencier les voitures
          Container(
            width: enemyCar.width.toScreenWidth(context),
            height: enemyCar.height.toScreenHeight(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: enemyCar.color.withOpacity(0.2),
            ),
          ),

          // Feux arrière (vers le bas)
          Positioned(
            top: 4,
            left: 8,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 8,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // Indicateur de type de voiture (optionnel)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _getIconForCarType(enemyCar.carType),
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getImagePathForCarType(CarType type) {
    switch (type) {
      case CarType.sports:
        return 'assets/images/cars/sports_car.png';
      case CarType.suv:
        return 'assets/images/cars/suv_car.png';
      case CarType.truck:
        return 'assets/images/cars/truck_car.png';
    }
  }

  IconData _getIconForCarType(CarType type) {
    switch (type) {
      case CarType.sports:
        return Icons.sports_motorsports;
      case CarType.suv:
        return Icons.terrain;
      case CarType.truck:
        return Icons.local_shipping;
    }
  }

  Widget _buildFallbackEnemyCar() {
    // Widget de secours en cas d'erreur de chargement d'image
    return Container(
      width: enemyCar.width,
      height: enemyCar.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            enemyCar.color.withOpacity(0.9),
            enemyCar.color,
            enemyCar.color.withOpacity(0.8),
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
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: enemyCar.color,
              border: Border.all(color: Colors.black26, width: 1),
            ),
          ),
          Center(
            child: Icon(
              _getIconForCarType(enemyCar.carType),
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}