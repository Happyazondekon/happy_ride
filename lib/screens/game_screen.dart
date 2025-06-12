import 'dart:ui';

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
        onPanUpdate: (details) {
          // Mouvement fluide avec support tactile amélioré
          final double sensitivity = 0.003;
          final double deltaX = details.delta.dx * sensitivity;

          if (deltaX.abs() > 0.001) {
            if (deltaX > 0) {
              context.read<GameService>().moveRight();
            } else {
              context.read<GameService>().moveLeft();
            }
          }
        },
        onTap: () {
          // Tap pour mettre en pause/reprendre
          final gameService = context.read<GameService>();
          if (gameService.state.isPlaying) {
            gameService.pauseGame();
          } else if (gameService.state.isPaused) {
            gameService.resumeGame();
          }
        },
        child: Consumer<GameService>(
          builder: (context, gameService, child) {
            // Navigation vers game over si le jeu est terminé
            if (gameService.state.isGameOver) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GameOverScreen()),
                );
              });
              return Container(
                color: GameConstants.backgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: GameConstants.primaryColor,
                  ),
                ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1a1a2e),
                    Color(0xFF16213e),
                    Color(0xFF0f3460),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Route avec effet de perspective
                  const RoadWidget(),

                  // Effet de brouillard/distance
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Voiture du joueur avec effet d'invincibilité
                  Positioned(
                    left: gameService.playerX.toScreenWidth(context) -
                        (GameConstants.carWidth.toScreenWidth(context) / 2),
                    top: gameService.playerY.toScreenHeight(context) -
                        (GameConstants.carHeight.toScreenHeight(context) / 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      child: _buildPlayerCar(gameService.state.isInvincible),
                    ),
                  ),

                  // Voitures ennemies avec animations d'entrée
                  ...gameService.enemyCars.asMap().entries.map((entry) {
                    final index = entry.key;
                    final enemyCar = entry.value;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 50),
                      left: enemyCar.x.toScreenWidth(context) -
                          (enemyCar.width.toScreenWidth(context) / 2),
                      top: enemyCar.y.toScreenHeight(context) -
                          (enemyCar.height.toScreenHeight(context) / 2),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: enemyCar.y < 0 ? 0.0 : 1.0,
                        child: Transform.scale(
                          scale: _getCarScale(enemyCar.y),
                          child: EnemyCarWidget(enemyCar: enemyCar),
                        ),
                      ),
                    );
                  }).toList(),

                  // Power-ups avec animations brillantes
                  ...gameService.powerUps.asMap().entries.map((entry) {
                    final powerUp = entry.value;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 50),
                      left: powerUp.x.toScreenWidth(context) - 20,
                      top: powerUp.y.toScreenHeight(context) - 20,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: powerUp.y < 0 ? 0.0 : 1.0,
                        child: PowerUpWidget(powerUp: powerUp),
                      ),
                    );
                  }).toList(),

                  // Effets visuels pour les power-ups actifs
                  if (gameService.state.isInvincible)
                    _buildInvincibilityEffect(),

                  if (gameService.state.isSlowMotion)
                    _buildSlowMotionEffect(),

                  // HUD redesigné
                  const HudWidget(),

                  // Indicateurs de performance
                  _buildPerformanceIndicators(gameService),

                  // Écran de pause redesigné
                  if (gameService.state.isPaused)
                    _buildPauseOverlay(context, gameService),

                  // Notification de combo
                  if (gameService.state.hasCombo)
                    _buildComboNotification(gameService.state.combo),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayerCar(bool isInvincible) {
    if (isInvincible) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            const CarWidget(),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const CarWidget();
  }

  double _getCarScale(double y) {
    // Effet de perspective : les voitures sont plus petites au loin
    return (0.5 + (y * 0.5)).clamp(0.3, 1.0);
  }

  Widget _buildInvincibilityEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue.withOpacity(0.3),
            width: 3,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.transparent,
                Colors.blue.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlowMotionEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              Colors.purple.withOpacity(0.1),
              Colors.purple.withOpacity(0.2),
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'SLOW MOTION',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicators(GameService gameService) {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          if (gameService.state.dodgeStreak > 3)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Text(
                'Streak: ${gameService.state.dodgeStreak}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (gameService.state.score % GameConstants.scorePerLevel) /
                  GameConstants.scorePerLevel,
              child: Container(
                decoration: BoxDecoration(
                  color: GameConstants.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboNotification(int combo) {
    return Positioned(
      top: 150,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            'COMBO x$combo',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context, GameService gameService) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: GameConstants.backgroundColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: GameConstants.primaryColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.pause_circle_filled,
                    color: GameConstants.primaryColor,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Game Paused',
                    style: TextStyle(
                      fontSize: 32,
                      color: GameConstants.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildPauseButton(
                    icon: Icons.play_arrow,
                    text: 'Resume',
                    color: Colors.green,
                    onPressed: () => gameService.resumeGame(),
                  ),
                  const SizedBox(height: 15),
                  _buildPauseButton(
                    icon: Icons.refresh,
                    text: 'Restart',
                    color: Colors.orange,
                    onPressed: () {
                      gameService.startGame();
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildPauseButton(
                    icon: Icons.home,
                    text: 'Main Menu',
                    color: Colors.red,
                    onPressed: () => gameService.returnToMenu(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}