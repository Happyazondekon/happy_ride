import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import 'start_screen.dart';
import 'game_screen.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = Provider.of<GameService>(context, listen: false);
    final state = gameService.state;

    return Scaffold(
      backgroundColor: GameConstants.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(GameConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: GameConstants.textColor,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Score: ${state.score.formatScore()}',
                style: const TextStyle(
                  fontSize: 32,
                  color: GameConstants.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'High Score: ${state.highScore.formatScore()}',
                style: const TextStyle(
                  fontSize: 32,
                  color: GameConstants.textColor,
                ),
              ),
              if (state.isNewHighScore)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'NEW HIGH SCORE!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: GameConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    gameService.startGame();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const GameScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GameConstants.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(GameConstants.borderRadius),
                    ),
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: GameConstants.textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: GameConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    gameService.returnToMenu();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const StartScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GameConstants.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(GameConstants.borderRadius),
                    ),
                  ),
                  child: const Text(
                    'Main Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: GameConstants.textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}