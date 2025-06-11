import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  late AudioPlayer _musicPlayer;
  late AudioPlayer _soundPlayer;

  bool _soundEnabled = true;
  bool _musicEnabled = true;

  Future<void> init() async {
    _musicPlayer = AudioPlayer();
    _soundPlayer = AudioPlayer();

    // Set up music player for looping
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.3);

    // Set up sound player
    await _soundPlayer.setVolume(0.7);
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;

    try {
      // Note: You'll need to add actual music files to assets/sounds/
      await _musicPlayer.play(AssetSource('sounds/background_music.mp3'));
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    await _musicPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    if (_musicEnabled) {
      await _musicPlayer.resume();
    }
  }

  Future<void> playCollisionSound() async {
    if (!_soundEnabled) return;

    try {
      await _soundPlayer.play(AssetSource('sounds/collision.mp3'));
      // Add vibration feedback
      HapticFeedback.heavyImpact();
    } catch (e) {
      print('Error playing collision sound: $e');
      // Fallback to system sound
      SystemSound.play(SystemSoundType.alert);
    }
  }

  Future<void> playPowerUpSound() async {
    if (!_soundEnabled) return;

    try {
      await _soundPlayer.play(AssetSource('sounds/power_up.mp3'));
      HapticFeedback.lightImpact();
    } catch (e) {
      print('Error playing power-up sound: $e');
      SystemSound.play(SystemSoundType.click);
    }
  }

  Future<void> playComboSound() async {
    if (!_soundEnabled) return;

    try {
      await _soundPlayer.play(AssetSource('sounds/combo.mp3'));
      HapticFeedback.selectionClick();
    } catch (e) {
      print('Error playing combo sound: $e');
    }
  }

  Future<void> playButtonSound() async {
    if (!_soundEnabled) return;

    try {
      SystemSound.play(SystemSoundType.click);
      HapticFeedback.selectionClick();
    } catch (e) {
      print('Error playing button sound: $e');
    }
  }

  Future<void> playLevelUpSound() async {
    if (!_soundEnabled) return;

    try {
      HapticFeedback.mediumImpact();
      // Play a sequence of clicks for level up
      for (int i = 0; i < 3; i++) {
        SystemSound.play(SystemSoundType.click);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      print('Error playing level up sound: $e');
    }
  }

  Future<void> playGameOverSound() async {
    if (!_soundEnabled) return;

    try {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      HapticFeedback.heavyImpact();
    } catch (e) {
      print('Error playing game over sound: $e');
    }
  }

  void dispose() {
    _musicPlayer.dispose();
    _soundPlayer.dispose();
  }
}