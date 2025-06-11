import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../widgets/hud_widget.dart';
import '../widgets/road_widget.dart';
import '../widgets/car_widget.dart';
import '../widgets/enemy_car_widget.dart';
import '../widgets/power_up_widget.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import 'game_over_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // This allows for continuous movement while dragging
          if (details.delta.dx > 0) {
            context.read<GameService>().moveRight();
          } else if (details.delta.dx < 0) {
            context.read<GameService>().moveLeft();
          }
        },
        child: Consumer<GameService>(
          builder: (context, gameService, child) {
            // Navigate to game over screen if game is over
            if (gameService.state.isGameOver) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GameOverScreen()),
                );
              });
              return Container(); // Return an empty container while navigating
            }

            return Stack(
              children: [
                const RoadWidget(),
                // Player Car
                Positioned(
                  left: gameService.playerX.toScreenWidth(context) - (GameConstants.carWidth.toScreenWidth(context) / 2),
                  top: gameService.playerY.toScreenHeight(context) - (GameConstants.carHeight.toScreenHeight(context) / 2),
                  child: const CarWidget(),
                ),
                // Enemy Cars
                ...gameService.enemyCars.map((enemyCar) {
                  return Positioned(
                    left: enemyCar.x.toScreenWidth(context) - (enemyCar.width.toScreenWidth(context) / 2),
                    top: enemyCar.y.toScreenHeight(context) - (enemyCar.height.toScreenHeight(context) / 2),
                    child: EnemyCarWidget(enemyCar: enemyCar),
                  );
                }).toList(),
                // Power-ups
                ...gameService.powerUps.map((powerUp) {
                  return Positioned(
                    left: powerUp.x.toScreenWidth(context) - 20, // Power-up width is 40
                    top: powerUp.y.toScreenHeight(context) - 20, // Power-up height is 40
                    child: PowerUpWidget(powerUp: powerUp),
                  );
                }).toList(),
                const HudWidget(),
                if (gameService.state.isPaused)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Paused',
                              style: TextStyle(
                                fontSize: 48,
                                color: GameConstants.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 200,
                              height: GameConstants.buttonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  gameService.resumeGame();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: GameConstants.buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(GameConstants.borderRadius),
                                  ),
                                ),
                                child: const Text(
                                  'Resume',
                                  style: TextStyle(fontSize: 24, color: GameConstants.textColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 200,
                              height: GameConstants.buttonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  gameService.returnToMenu();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: GameConstants.buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(GameConstants.borderRadius),
                                  ),
                                ),
                                child: const Text(
                                  'Main Menu',
                                  style: TextStyle(fontSize: 24, color: GameConstants.textColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}