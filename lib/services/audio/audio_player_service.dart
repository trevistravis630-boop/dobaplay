import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService {
  AudioPlayerService._();

  static final AudioPlayer instance = AudioPlayer();

  static Future<void> play(String url) async {
    try {
      await instance.setUrl(url);
      await instance.play();
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  static Future<void> pause() async {
    await instance.pause();
  }

  static Future<void> stop() async {
    await instance.stop();
  }

  static Future<void> dispose() async {
    await instance.dispose();
  }
}