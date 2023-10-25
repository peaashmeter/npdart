import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

///A singleton for managing audio-channels
class AudioManager {
  static AudioManager? instance;

  factory AudioManager() {
    instance ??= AudioManager._();
    return instance!;
  }
  AudioManager._();

  AudioPlayer? _backgroundPlayer;

  playSound(String assetPath, {double volume = 1}) async {
    try {
      final player = AudioPlayer();
      await player.play(AssetSource(assetPath),
          volume: volume, mode: PlayerMode.lowLatency);
      player.onPlayerComplete.listen((event) {
        player.dispose();
      });
    } catch (e) {
      log('[AUDIO] $e', error: e);
    }
  }

  ///If an old player exists, applies crossfade.
  playBackgroundSound(String assetPath, {double volume = 1}) async {
    try {
      if (_backgroundPlayer != null) {
        await smoothlyStopBackground(const Duration(milliseconds: 1000));
      }
      _backgroundPlayer = AudioPlayer(
        playerId: 'background',
      );
      await _backgroundPlayer!.play(
        AssetSource(assetPath),
        volume: 0.0,
        mode: PlayerMode.mediaPlayer,
      );
      await lerpBackroundVolume(volume, const Duration(milliseconds: 1000));
    } catch (e) {
      log('[AUDIO] $e', error: e);
    }
  }

  pauseBackgroundSound() => _backgroundPlayer?.pause();

  resumeBackgroundSound() => _backgroundPlayer?.resume();

  setBackroudVolume(double volume) => _backgroundPlayer?.setVolume(volume);

  ///Lineary interpolates the volume of background to zero, then disposes it.
  Future<void> smoothlyStopBackground(Duration time) async {
    await lerpBackroundVolume(0, time);
    await _backgroundPlayer?.dispose();
    _backgroundPlayer = null;
  }

  Future<void> lerpBackroundVolume(double to, Duration time) {
    if (_backgroundPlayer == null) return Future.value();
    final result = Completer();

    final delta = to - _backgroundPlayer!.volume;
    final start = _backgroundPlayer!.volume;
    //assuming one audio tick as 1/20 of a second
    final ticks = time.inSeconds * 20;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (timer.tick == ticks) {
        result.complete();
        timer.cancel();
      }
      final v = start + delta * timer.tick / ticks;
      _backgroundPlayer!.setVolume(v);
    });

    return result.future;
  }
}
