import 'package:flutter_tts/flutter_tts.dart';

/// A service class to handle Text-to-Speech (TTS) configuration.
class TTSService {
  final FlutterTts flutterTts = FlutterTts();

  /// Constructor to initialize and configure the TTS settings.
  TTSService() {
    _configureTTS();
  }

  /// Configures the TTS settings such as language, speech rate, volume, and pitch.
  void _configureTTS() {
    flutterTts.setLanguage("en-UK");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(0.8);
  }

}