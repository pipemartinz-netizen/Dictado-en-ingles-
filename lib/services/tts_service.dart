import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Envuelve el motor de TTS. Soporta acento americano o británico,
/// y permite elegir entre las voces instaladas en el dispositivo.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  String _accent = 'US'; // 'US' o 'GB'

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _tts.setLanguage(_accent == 'US' ? 'en-US' : 'en-GB');
    await _tts.setPitch(1.0);
    _initialized = true;
    await _applySavedVoice();
  }

  Future<void> setAccent(String accent) async {
    _accent = accent;
    await _tts.setLanguage(accent == 'US' ? 'en-US' : 'en-GB');
    await _applySavedVoice();
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

  /// Devuelve solo las voces en inglés instaladas en el celular.
  Future<List<Map<String, String>>> getEnglishVoices() async {
    await _ensureInit();
    final voices = await _tts.getVoices;
    final result = <Map<String, String>>[];
    for (final v in voices) {
      final map = Map<String, dynamic>.from(v as Map);
      final locale = (map['locale'] ?? '').toString();
      if (locale.toLowerCase().startsWith('en')) {
        result.add({
          'name': (map['name'] ?? '').toString(),
          'locale': locale,
        });
      }
    }
    return result;
  }

  /// Guarda y aplica la voz elegida por el usuario para el acento actual.
  Future<void> setChosenVoice(String name, String locale) async {
    await _tts.setVoice({'name': name, 'locale': locale});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voice_name_$_accent', name);
    await prefs.setString('voice_locale_$_accent', locale);
  }

  Future<void> _applySavedVoice() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('voice_name_$_accent');
    final locale = prefs.getString('voice_locale_$_accent');
    if (name != null && locale != null) {
      await _tts.setVoice({'name': name, 'locale': locale});
    }
  }
}
