import 'dart:async';
import 'dart:developer';

import 'package:just_audio/just_audio.dart';

///A class for managing audio-channels.
class AudioManager {
  AudioPlayer? _backgroundPlayer;

  playSound(String assetPath, {double volume = 1}) async {
    try {
      final player = AudioPlayer();
      player.setAsset(assetPath);
      player.setVolume(volume);
      player.play();
      player.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          player.dispose();
        }
      });
    } catch (e) {
      log('[AUDIO] $e', error: e);
    }
  }

  ///If a song is already playing, applies crossfade.
  playBackgroundSound(String assetPath, {double volume = 1}) async {
    try {
      if (_backgroundPlayer != null) {
        await smoothlyStopBackground(const Duration(milliseconds: 1000));
      }
      _backgroundPlayer = AudioPlayer();
      _backgroundPlayer?.setAsset(assetPath);
      _backgroundPlayer?.setVolume(0);
      _backgroundPlayer?.setLoopMode(LoopMode.one);
      _backgroundPlayer?.play();

      await lerpBackroundVolume(volume, const Duration(milliseconds: 1000));
    } catch (e) {
      log('[AUDIO] $e', error: e);
    }
  }

  pauseBackgroundSound() => _backgroundPlayer?.pause();

  resumeBackgroundSound() => _backgroundPlayer?.play();

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
      if (timer.tick >= ticks) {
        result.complete();
        timer.cancel();
      }
      final v = start + delta * timer.tick / ticks;
      _backgroundPlayer!.setVolume(v);
    });

    return result.future;
  }
}
