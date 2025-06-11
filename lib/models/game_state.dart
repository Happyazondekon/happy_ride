import '../utils/constants.dart';

class GameStateModel {
  final int score;
  final int combo;
  final int lives;
  final int level;
  final double gameSpeed;
  final GameState gameState;
  final bool isInvincible;
  final bool isSlowMotion;
  final int powerUpEndTime;
  final int dodgeStreak;
  final int lastDodgeTime;
  final Difficulty difficulty;
  final bool soundEnabled;
  final bool musicEnabled;
  final int highScore;

  const GameStateModel({
    this.score = 0,
    this.combo = 0,
    this.lives = GameConstants.initialLives,
    this.level = 1,
    this.gameSpeed = GameConstants.initialGameSpeed,
    this.gameState = GameState.menu,
    this.isInvincible = false,
    this.isSlowMotion = false,
    this.powerUpEndTime = 0,
    this.dodgeStreak = 0,
    this.lastDodgeTime = 0,
    this.difficulty = Difficulty.medium,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.highScore = 0,
  });

  GameStateModel copyWith({
    int? score,
    int? combo,
    int? lives,
    int? level,
    double? gameSpeed,
    GameState? gameState,
    bool? isInvincible,
    bool? isSlowMotion,
    int? powerUpEndTime,
    int? dodgeStreak,
    int? lastDodgeTime,
    Difficulty? difficulty,
    bool? soundEnabled,
    bool? musicEnabled,
    int? highScore,
  }) {
    return GameStateModel(
      score: score ?? this.score,
      combo: combo ?? this.combo,
      lives: lives ?? this.lives,
      level: level ?? this.level,
      gameSpeed: gameSpeed ?? this.gameSpeed,
      gameState: gameState ?? this.gameState,
      isInvincible: isInvincible ?? this.isInvincible,
      isSlowMotion: isSlowMotion ?? this.isSlowMotion,
      powerUpEndTime: powerUpEndTime ?? this.powerUpEndTime,
      dodgeStreak: dodgeStreak ?? this.dodgeStreak,
      lastDodgeTime: lastDodgeTime ?? this.lastDodgeTime,
      difficulty: difficulty ?? this.difficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      highScore: highScore ?? this.highScore,
    );
  }

  bool get isPlaying => gameState == GameState.playing;
  bool get isPaused => gameState == GameState.paused;
  bool get isGameOver => gameState == GameState.gameOver;
  bool get isMenu => gameState == GameState.menu;

  bool get hasCombo => combo > 0;
  bool get isNewHighScore => score > highScore;

  double get difficultyMultiplier {
    switch (difficulty) {
      case Difficulty.easy:
        return 0.8;
      case Difficulty.medium:
        return 1.0;
      case Difficulty.hard:
        return 1.3;
    }
  }
}