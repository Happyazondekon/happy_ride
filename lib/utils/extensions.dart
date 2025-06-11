import 'package:flutter/material.dart';

import 'constants.dart';

extension DoubleExtension on double {
  double toScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * this;
  }

  double toScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * this;
  }
}

extension IntExtension on int {
  String formatScore() {
    return toString().padLeft(6, '0');
  }
}

extension GameStateExtension on GameState {
  String get displayName {
    switch (this) {
      case GameState.menu:
        return 'Menu';
      case GameState.playing:
        return 'Playing';
      case GameState.paused:
        return 'Paused';
      case GameState.gameOver:
        return 'Game Over';
    }
  }
}