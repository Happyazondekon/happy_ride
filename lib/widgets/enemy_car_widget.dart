import 'package:flutter/material.dart';
import '../models/car.dart';
import '../utils/extensions.dart';
import '../utils/constants.dart'; // Import constants.dart to define CarType

class EnemyCarWidget extends StatelessWidget {
  final EnemyCar enemyCar;

  const EnemyCarWidget({super.key, required this.enemyCar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: enemyCar.width.toScreenWidth(context),
      height: enemyCar.height.toScreenHeight(context),
      decoration: BoxDecoration(
        color: EnemyCar.getColorForType(enemyCar.carType),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Icon(
          _getIconForCarType(enemyCar.carType),
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  IconData _getIconForCarType(CarType type) {
    switch (type) {
      case CarType.sports:
        return Icons.directions_car_filled;
      case CarType.suv:
        return Icons.local_taxi;
      case CarType.truck:
        return Icons.local_shipping_outlined; // Corrected icon
    }
  }
}