import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:palette_generator/palette_generator.dart'; // Extraer el color
import '../models/track.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Track? _currentTrack;
  bool _isPlaying = false;

  Color _themeColor = Colors.deepPurple;
  Color get themeColor => _themeColor;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;

  // Escuchar si la cancion termina sola

  MusicProvider() {
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> playTrack(Track track) async {
    if (_currentTrack?.id == track.id){
      if (_isPlaying){
        await _audioPlayer.pause();
        _isPlaying = false;
      } else {
        await _audioPlayer.resume();
        _isPlaying = true;

        _updateThemeColor(track.image);
      }
    } else {
      _currentTrack = track;
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(track.previewUrl));
      _isPlaying = false;
    }

    if (await Vibration.hasVibrator()){
      Vibration.vibrate(duration: 40, amplitude: 100);
    }
    notifyListeners();
  }

  Future<void>_updateThemeColor(String imageUrl) async {
    try {
      final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        size: const Size(200, 200),
      );
      
      _themeColor = paletteGenerator.vibrantColor?.color ??
                    paletteGenerator.dominantColor?.color ??
                    Colors.deepPurple;
    } catch (e) {
      _themeColor = Colors.deepPurple;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentTrack = null;
    _isPlaying = false;
    notifyListeners();
  }
}