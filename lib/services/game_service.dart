import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/car.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class GameService extends ChangeNotifier {
  final StorageService storageService;
  final AudioService audioService;

  GameStateModel _state = GameStateModel();
  Timer? _gameTimer;
  Timer? _powerUpTimer;
  DateTime? _lastUpdateTime;

  // Player car position
  double _playerX = 0.5;
  double _playerY = 0.8;

  // Game objects
  final List<EnemyCar> _enemyCars = [];
  final List<PowerUp> _powerUps = [];

  GameService({
    required this.storageService,
    required this.audioService,
  }) {
    // Load saved preferences
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final soundEnabled = await storageService.getSoundEnabled();
    final musicEnabled = await storageService.getMusicEnabled();
    final difficulty = await storageService.getDifficulty();
    final highScore = await storageService.getHighScore();

    _state = _state.copyWith(
      soundEnabled: soundEnabled,
      musicEnabled: musicEnabled,
      difficulty: difficulty,
      highScore: highScore,
    );

    audioService.setSoundEnabled(soundEnabled);
    audioService.setMusicEnabled(musicEnabled);
  }

  // Game state getters
  GameStateModel get state => _state;
  double get playerX => _playerX;
  double get playerY => _playerY;
  List<EnemyCar> get enemyCars => _enemyCars;
  List<PowerUp> get powerUps => _powerUps;

  // Game control methods
  void startGame() {
    _state = GameStateModel(
      gameState: GameState.playing,
      soundEnabled: _state.soundEnabled,
      musicEnabled: _state.musicEnabled,
      difficulty: _state.difficulty,
      highScore: _state.highScore,
    );

    _playerX = 0.5;
    _playerY = 0.8;
    _enemyCars.clear();
    _powerUps.clear();

    audioService.playBackgroundMusic();
    _startGameLoop();
    notifyListeners();
  }

  void _startGameLoop() {
    _lastUpdateTime = DateTime.now();
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: 16), // ~60 FPS
          (timer) => _updateGame(),
    );
  }

  void pauseGame() {
    _state = _state.copyWith(gameState: GameState.paused);
    _gameTimer?.cancel();
    audioService.pauseBackgroundMusic();
    notifyListeners();
  }

  void resumeGame() {
    _state = _state.copyWith(gameState: GameState.playing);
    _lastUpdateTime = DateTime.now();
    _startGameLoop();
    audioService.resumeBackgroundMusic();
    notifyListeners();
  }

  void endGame() {
    _gameTimer?.cancel();
    _powerUpTimer?.cancel();

    if (_state.isNewHighScore) {
      storageService.saveHighScore(_state.score);
    }

    _state = _state.copyWith(gameState: GameState.gameOver);
    audioService.playGameOverSound();
    audioService.stopBackgroundMusic();
    notifyListeners();
  }

  void returnToMenu() {
    _gameTimer?.cancel();
    _powerUpTimer?.cancel();
    _state = _state.copyWith(gameState: GameState.menu);
    audioService.stopBackgroundMusic();
    notifyListeners();
  }

  // Game logic
  void _updateGame() {
    final now = DateTime.now();
    final elapsed = now.difference(_lastUpdateTime!).inMilliseconds;
    _lastUpdateTime = now;

    if (_state.isPlaying) {
      _updatePlayerPosition();
      _spawnObjects(elapsed);
      _updateObjects(elapsed);
      _checkCollisions();
      _updateGameState(elapsed);
    }

    notifyListeners();
  }

  void _updatePlayerPosition() {
    // Player movement is handled by touch events
  }

  void _spawnObjects(int elapsed) {
    // Spawn enemy cars
    if (DateTime.now().millisecondsSinceEpoch % 2000 < elapsed) {
      final lane = (DateTime.now().millisecondsSinceEpoch % 3) / 2; // 0, 0.5 or 1
      _enemyCars.add(EnemyCar(
        x: lane,
        y: -0.1,
        carType: EnemyCar.getRandomType(),
        spawnTime: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    // Spawn power-ups
    if (DateTime.now().millisecondsSinceEpoch % 5000 < elapsed) {
      final lane = (DateTime.now().millisecondsSinceEpoch % 3) / 2;
      _powerUps.add(PowerUp(
        x: lane,
        y: -0.1,
        type: PowerUp.getRandomType(),
        spawnTime: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  void _updateObjects(int elapsed) {
    // Update enemy cars
    final speed = _state.gameSpeed * _state.difficultyMultiplier * (elapsed / 16);
    for (var car in _enemyCars) {
      car = car.copyWith(y: car.y + 0.01 * speed);
    }
    _enemyCars.removeWhere((car) => car.y > 1.2);

    // Update power-ups
    for (var powerUp in _powerUps) {
      powerUp = powerUp.copyWith(y: powerUp.y + 0.005 * speed);
    }
    _powerUps.removeWhere((powerUp) => powerUp.y > 1.2);
  }

  void _checkCollisions() {
    final playerCar = Car(x: _playerX, y: _playerY);

    // Check power-up collisions
    for (var powerUp in _powerUps) {
      if (powerUp.collidesWith(playerCar)) {
        _applyPowerUp(powerUp);
        _powerUps.remove(powerUp);
        break;
      }
    }

    // Check enemy car collisions
    if (!_state.isInvincible) {
      for (var enemy in _enemyCars) {
        if (enemy.collidesWith(playerCar)) {
          _handleCollision();
          _enemyCars.remove(enemy);
          break;
        }
      }
    }
  }

  void _applyPowerUp(PowerUp powerUp) {
    audioService.playPowerUpSound();

    switch (powerUp.type) {
      case PowerUpType.invincibility:
        _state = _state.copyWith(
          isInvincible: true,
          powerUpEndTime: DateTime.now().millisecondsSinceEpoch + 5000,
        );
        _powerUpTimer = Timer(const Duration(seconds: 5), () {
          _state = _state.copyWith(isInvincible: false);
          notifyListeners();
        });
        break;
      case PowerUpType.slowMotion:
        _state = _state.copyWith(
          isSlowMotion: true,
          gameSpeed: _state.gameSpeed * 0.5,
          powerUpEndTime: DateTime.now().millisecondsSinceEpoch + 3000,
        );
        _powerUpTimer = Timer(const Duration(seconds: 3), () {
          _state = _state.copyWith(
            isSlowMotion: false,
            gameSpeed: _state.gameSpeed * 2.0,
          );
          notifyListeners();
        });
        break;
      case PowerUpType.extraLife:
        _state = _state.copyWith(lives: _state.lives + 1);
        break;
    }
  }

  void _handleCollision() {
    audioService.playCollisionSound();
    _state = _state.copyWith(
      lives: _state.lives - 1,
      combo: 0,
      dodgeStreak: 0,
    );

    if (_state.lives <= 0) {
      endGame();
    }
  }

  void _updateGameState(int elapsed) {
    // Update score
    _state = _state.copyWith(score: _state.score + (1 * _state.level));

    // Level progression
    if (_state.score >= _state.level * GameConstants.scorePerLevel) {
      _state = _state.copyWith(
        level: _state.level + 1,
        gameSpeed: _state.gameSpeed * GameConstants.speedIncreaseFactor,
      );
      audioService.playLevelUpSound();
    }
  }

  // Player controls
  void moveLeft() {
    if (_state.isPlaying) {
      _playerX = (_playerX - 0.1).clamp(0.0, 1.0);
      _checkDodge();
      notifyListeners();
    }
  }

  void moveRight() {
    if (_state.isPlaying) {
      _playerX = (_playerX + 0.1).clamp(0.0, 1.0);
      _checkDodge();
      notifyListeners();
    }
  }

  void _checkDodge() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _state.lastDodgeTime < 1000) {
      _state = _state.copyWith(
        dodgeStreak: _state.dodgeStreak + 1,
        lastDodgeTime: now,
      );

      if (_state.dodgeStreak % 5 == 0) {
        _state = _state.copyWith(combo: _state.combo + 1);
        audioService.playComboSound();
      }
    } else {
      _state = _state.copyWith(
        dodgeStreak: 1,
        lastDodgeTime: now,
      );
    }
  }

  // Settings
  void toggleSound() {
    _state = _state.copyWith(soundEnabled: !_state.soundEnabled);
    audioService.setSoundEnabled(_state.soundEnabled);
    storageService.setSoundEnabled(_state.soundEnabled);
    notifyListeners();
  }

  void toggleMusic() {
    _state = _state.copyWith(musicEnabled: !_state.musicEnabled);
    audioService.setMusicEnabled(_state.musicEnabled);
    storageService.setMusicEnabled(_state.musicEnabled);

    if (_state.musicEnabled && _state.isPlaying) {
      audioService.playBackgroundMusic();
    } else {
      audioService.stopBackgroundMusic();
    }

    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    _state = _state.copyWith(difficulty: difficulty);
    storageService.setDifficulty(difficulty);
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _powerUpTimer?.cancel();
    super.dispose();
  }
}