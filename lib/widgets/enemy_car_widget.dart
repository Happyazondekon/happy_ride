import 'package:flutter/material.dart';
import '../models/car.dart';
import '../utils/extensions.dart';
import '../utils/constants.dart';

class EnemyCarWidget extends StatelessWidget {
  final EnemyCar enemyCar;

  const EnemyCarWidget({super.key, required this.enemyCar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: enemyCar.width.toScreenWidth(context),
      height: enemyCar.height.toScreenHeight(context),
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
          // Carrosserie principale
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: enemyCar.color,
              border: Border.all(color: Colors.black26, width: 1),
            ),
          ),
          // Pare-brise avant
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            height: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                color: Colors.lightBlue.withOpacity(0.3),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
            ),
          ),
          // Pare-brise arrière
          Positioned(
            top: 4,
            left: 4,
            right: 4,
            height: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                color: Colors.lightBlue.withOpacity(0.2),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
            ),
          ),
          // Feux arrière (vers le bas)
          Positioned(
            top: 2,
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
            top: 2,
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
          // Indicateur de type de voiture
          Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(
                _getIconForCarType(enemyCar.carType),
                color: enemyCar.color,
                size: 12,
              ),
            ),
          ),
          // Modification selon le type
          if (enemyCar.carType == CarType.truck) ...[
            // Remorque pour les camions
            Positioned(
              top: -2,
              left: 3,
              right: 3,
              height: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: enemyCar.color.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Colors.black26, width: 0.5),
                ),
              ),
            ),
          ],
          if (enemyCar.carType == CarType.sports) ...[
            // Aileron pour les voitures de sport
            Positioned(
              top: 1,
              left: 6,
              right: 6,
              height: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ],
        ],
      ),
    );
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
}