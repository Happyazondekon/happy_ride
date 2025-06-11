import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class StorageService {
  static const String _soundEnabledKey = 'soundEnabled';
  static const String _musicEnabledKey = 'musicEnabled';
  static const String _difficultyKey = 'difficulty';
  static const String _highScoreKey = 'highScore';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Sound settings
  Future<bool> getSoundEnabled() async {
    return _prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }

  // Music settings
  Future<bool> getMusicEnabled() async {
    return _prefs.getBool(_musicEnabledKey) ?? true;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool(_musicEnabledKey, enabled);
  }

  // Difficulty settings
  Future<Difficulty> getDifficulty() async {
    final index = _prefs.getInt(_difficultyKey) ?? 1; // Default to medium
    return Difficulty.values[index.clamp(0, Difficulty.values.length - 1)];
  }

  Future<void> setDifficulty(Difficulty difficulty) async {
    await _prefs.setInt(_difficultyKey, difficulty.index);
  }

  // High score
  Future<int> getHighScore() async {
    return _prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> saveHighScore(int score) async {
    final currentHighScore = await getHighScore();
    if (score > currentHighScore) {
      await _prefs.setInt(_highScoreKey, score);
    }
  }
}