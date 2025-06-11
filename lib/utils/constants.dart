import 'package:flutter/material.dart';

enum GameState { menu, playing, paused, gameOver }
enum CarType { sports, suv, truck }
enum PowerUpType { invincibility, slowMotion, extraLife }
enum Difficulty { easy, medium, hard }

class GameConstants {
  // Gameplay constants
  static const initialLives = 3;
  static const initialGameSpeed = 1.0;
  static const speedIncreaseFactor = 1.1;
  static const scorePerLevel = 1000;

  // Car constants
  static const carWidth = 0.1;
  static const carHeight = 0.15;
  static const primaryColor = Colors.blue;

  // Power-up constants
  static const invincibilityColor = Colors.yellow;
  static const slowMotionColor = Colors.blueAccent;
  static const extraLifeColor = Colors.green;

  // UI constants
  static const defaultPadding = 16.0;
  static const buttonHeight = 50.0;
  static const borderRadius = 10.0;

  // Colors
  static const backgroundColor = Color(0xFF121212);
  static const primarySwatch = Colors.red;
  static const textColor = Colors.white;
  static const buttonColor = Colors.redAccent;
}