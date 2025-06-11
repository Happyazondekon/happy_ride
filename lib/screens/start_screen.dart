import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../utils/constants.dart';
import 'game_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = Provider.of<GameService>(context, listen: false);

    return Scaffold(
      backgroundColor: GameConstants.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(GameConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Happy Ride',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: GameConstants.textColor,
                ),
              ),
              const SizedBox(height: 50),
              _buildMenuItem(
                context,
                text: 'Start Game',
                onTap: () {
                  gameService.startGame();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuItem(
                context,
                text: 'Settings',
                onTap: () => _showSettingsDialog(context, gameService),
              ),
              const SizedBox(height: 20),
              Consumer<GameService>(
                builder: (context, gameService, child) {
                  return Text(
                    'High Score: ${gameService.state.highScore}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: GameConstants.textColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: GameConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: GameConstants.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GameConstants.borderRadius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: GameConstants.textColor,
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, GameService gameService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: GameConstants.backgroundColor,
          title: const Text(
            'Settings',
            style: TextStyle(color: GameConstants.textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<GameService>(
                builder: (context, gameService, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sound',
                        style: TextStyle(color: GameConstants.textColor),
                      ),
                      Switch(
                        value: gameService.state.soundEnabled,
                        onChanged: (value) {
                          gameService.toggleSound();
                        },
                        activeColor: GameConstants.primarySwatch,
                      ),
                    ],
                  );
                },
              ),
              Consumer<GameService>(
                builder: (context, gameService, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Music',
                        style: TextStyle(color: GameConstants.textColor),
                      ),
                      Switch(
                        value: gameService.state.musicEnabled,
                        onChanged: (value) {
                          gameService.toggleMusic();
                        },
                        activeColor: GameConstants.primarySwatch,
                      ),
                    ],
                  );
                },
              ),
              Consumer<GameService>(
                builder: (context, gameService, child) {
                  return DropdownButton<Difficulty>(
                    value: gameService.state.difficulty,
                    dropdownColor: GameConstants.backgroundColor,
                    onChanged: (Difficulty? newValue) {
                      if (newValue != null) {
                        gameService.setDifficulty(newValue);
                      }
                    },
                    items: Difficulty.values.map<DropdownMenuItem<Difficulty>>(
                          (Difficulty value) {
                        return DropdownMenuItem<Difficulty>(
                          value: value,
                          child: Text(
                            value.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(color: GameConstants.textColor),
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: GameConstants.primarySwatch),
              ),
            ),
          ],
        );
      },
    );
  }
}