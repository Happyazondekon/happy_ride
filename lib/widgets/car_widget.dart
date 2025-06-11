import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class CarWidget extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const CarWidget({
    super.key,
    this.color = GameConstants.primaryColor,
    this.width = GameConstants.carWidth,
    this.height = GameConstants.carHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toScreenWidth(context),
      height: height.toScreenHeight(context),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(
        child: Icon(
          Icons.car_rental, // You can use an actual car image asset here
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}