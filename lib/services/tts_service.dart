import 'package:flutter_tts/flutter_tts.dart';

/// Envuelve el motor de TTS. Soporta acento americano o británico.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  String _accent = 'US'; // 'US' o 'GB'

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _tts.setLanguage(_accent == 'US' ? 'en-US' : 'en-GB');
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// Cambia el acento de la voz: 'US' (americano) o 'GB' (británico).
  Future<void> setAccent(String accent) async {
    _accent = accent;
    await _tts.setLanguage(accent == 'US' ? 'en-US' : 'en-GB');
  }

  String get accent => _accent;

  Future<void> speak(String text, {double speed = 1.0}) async {
    await _ensureInit();
    final mappedRate = (speed * 0.5).clamp(0.1, 1.0);
    await _tts.setSpeechRate(mappedRate);
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();

  Future<List<dynamic>> getAvailableVoices() async {
    await _ensureInit();
    return await _tts.getVoices;
  }

  Future<void> setVoice(Map<String, String> voice) async {
    await _ensureInit();
    await _tts.setVoice(voice);
  }
}
