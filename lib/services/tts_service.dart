import 'package:flutter_tts/flutter_tts.dart';

/// Envuelve el motor de TTS.
///
/// Esta clase es la única que sabe cómo "hablar". Si en el futuro
/// quieres usar ElevenLabs o Azure Neural Voices en vez del TTS del
/// dispositivo, solo tienes que crear otra clase con los mismos
/// métodos (speak, stop, setSpeed, setVoice) y reemplazar esta,
/// sin tocar el resto de la app.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// Habla el texto dado. [speed] va de 0.25 a 2.0 (1.0 = velocidad normal).
  Future<void> speak(String text, {double speed = 1.0}) async {
    await _ensureInit();
    // flutter_tts usa un rango 0.0–1.0 en Android para setSpeechRate,
    // así que mapeamos nuestro 0.25x–2.0x a ese rango de forma aproximada.
    final mappedRate = (speed * 0.5).clamp(0.1, 1.0);
    await _tts.setSpeechRate(mappedRate);
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();

  /// Devuelve las voces disponibles en el dispositivo (varía según el
  /// idioma y el fabricante). Útil para armar el catálogo de voces.
  Future<List<dynamic>> getAvailableVoices() async {
    await _ensureInit();
    return await _tts.getVoices;
  }

  Future<void> setVoice(Map<String, String> voice) async {
    await _ensureInit();
    await _tts.setVoice(voice);
  }
}
