import '../models/sentence.dart';

/// Divide un texto libre (pegado por el usuario) en oraciones
/// individuales, para usarlas como dictado.
///
/// Es una división simple basada en puntuación (. ! ?). No maneja
/// casos especiales como abreviaturas ("Mr.", "e.g.") — para eso,
/// más adelante conviene una librería de segmentación de oraciones
/// o un modelo de IA.
class TextSplitter {
  static List<DictationSentence> splitIntoSentences(String rawText) {
    final cleaned = rawText.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return [];

    final matches = RegExp(r'[^.!?]+[.!?]*').allMatches(cleaned);

    final sentences = matches
        .map((m) => m.group(0)!.trim())
        .where((s) => s.isNotEmpty && s.length > 1)
        .toList();

    return List.generate(
      sentences.length,
      (i) => DictationSentence(
        id: 'custom_$i',
        text: sentences[i],
        topic: 'Texto personalizado',
      ),
    );
  }
}
