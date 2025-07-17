import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  String? sourceId;
  String title = '';
  String imageUrl = '';
  String audioUrl = '';
  double volume = 1.0;
  String? sourceType;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  bool get isPlaying => _player.playing;

  AudioPlayerProvider() {
    _player.positionStream.listen((pos) {
      position = pos;
      notifyListeners();
    });

    _player.durationStream.listen((dur) {
      duration = dur ?? Duration.zero;
      notifyListeners();
    });

    _player.playerStateStream.listen((state) {
      notifyListeners();
    });
  }

  Future<void> playSource({
    required String sourceId,
    required String title,
    required String imageUrl,
    required String audioUrl,
    required String sourceType,
  }) async {
    if (this.sourceId != sourceId) {
      this.sourceId = sourceId;
      this.title = title;
      this.imageUrl = imageUrl;
      this.audioUrl = audioUrl;
      this.sourceType = sourceType;
      await _player.setUrl(audioUrl);
    }

    _player.play();
    notifyListeners();
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void setVolume(double volume) {
    this.volume = volume;
    _player.setVolume(volume);
    notifyListeners();
  }

  void resume() {
    _player.play();
    notifyListeners();
  }

  void seek(Duration duration) {
    _player.seek(duration);
  }

  void seekToNext() {
    // Optional – chỉ dùng nếu có playlist
  }

  void seekToPrevious() {
    // Optional – chỉ dùng nếu có playlist
  }

  void stop() {
    _player.stop();
    sourceId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
