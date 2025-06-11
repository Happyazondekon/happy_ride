import 'package:flutter/material.dart';
import '../utils/constants.dart';

class Car {
  final double x;
  final double y;
  final double width;
  final double height;
  final Color color;

  const Car({
    required this.x,
    required this.y,
    this.width = GameConstants.carWidth,
    this.height = GameConstants.carHeight,
    this.color = GameConstants.primaryColor,
  });

  Car copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    Color? color,
  }) {
    return Car(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
    );
  }

  Rect get rect => Rect.fromLTWH(x, y, width, height);

  bool collidesWith(Car other) {
    return rect.overlaps(other.rect);
  }
}

class EnemyCar extends Car {
  final CarType carType;
  final int spawnTime;

  const EnemyCar({
    required super.x,
    required super.y,
    required this.carType,
    required this.spawnTime,
    super.width,
    super.height,
    super.color,
  });

  EnemyCar copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    Color? color,
    CarType? carType,
    int? spawnTime,
  }) {
    return EnemyCar(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      carType: carType ?? this.carType,
      spawnTime: spawnTime ?? this.spawnTime,
    );
  }

  static Color getColorForType(CarType type) {
    switch (type) {
      case CarType.sports:
        return Colors.red;
      case CarType.suv:
        return Colors.green;
      case CarType.truck:
        return Colors.purple;
    }
  }

  static CarType getRandomType() {
    final types = CarType.values;
    return types[DateTime.now().millisecondsSinceEpoch % types.length];
  }
}

class PowerUp {
  final double x;
  final double y;
  final PowerUpType type;
  final int spawnTime;

  const PowerUp({
    required this.x,
    required this.y,
    required this.type,
    required this.spawnTime,
  });

  PowerUp copyWith({
    double? x,
    double? y,
    PowerUpType? type,
    int? spawnTime,
  }) {
    return PowerUp(
      x: x ?? this.x,
      y: y ?? this.y,
      type: type ?? this.type,
      spawnTime: spawnTime ?? this.spawnTime,
    );
  }

  Rect get rect => Rect.fromLTWH(x, y, 40, 40);

  bool collidesWith(Car car) {
    return rect.overlaps(car.rect);
  }

  Color get color {
    switch (type) {
      case PowerUpType.invincibility:
        return GameConstants.invincibilityColor;
      case PowerUpType.slowMotion:
        return GameConstants.slowMotionColor;
      case PowerUpType.extraLife:
        return GameConstants.extraLifeColor;
    }
  }

  String get emoji {
    switch (type) {
      case PowerUpType.invincibility:
        return '🛡️';
      case PowerUpType.slowMotion:
        return '⏱️';
      case PowerUpType.extraLife:
        return '❤️';
    }
  }

  static PowerUpType getRandomType() {
    final types = PowerUpType.values;
    return types[DateTime.now().millisecondsSinceEpoch % types.length];
  }
}