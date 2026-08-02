import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Envuelve el reconocimiento de voz del dispositivo, usado para
/// que el usuario practique pronunciación: graba lo que dice y lo
/// convierte a texto, para compararlo con la oración correcta.
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;

  Future<bool> init() async {
    _available = await _speech.initialize();
    return _available;
  }

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  /// Empieza a escuchar. [onResult] recibe el texto reconocido
  /// cada vez que se actualiza (parcial o final).
  /// [accent] es 'US' o 'GB', para ajustar el reconocedor.
  Future<void> listen({
    required void Function(String recognizedText, bool isFinal) onResult,
    String accent = 'US',
  }) async {
    if (!_available) {
      final ok = await init();
      if (!ok) return;
    }
    await _speech.listen(
      localeId: accent == 'US' ? 'en_US' : 'en_GB',
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  Future<void> stop() => _speech.stop();
}
