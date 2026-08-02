/// Representa una frase de dictado con sus metadatos.
///
/// En el futuro, esto se puede alimentar desde SQLite/Hive local
/// o desde un backend (Firebase/Supabase) en vez de datos fijos.
enum DifficultyLevel { a1, a2, b1, b2, c1, c2 }

class DictationSentence {
  final String id;
  final String text; // Oración correcta en inglés (lo que el usuario debe escribir)
  final String topic; // Ej: "Saludos", "Viajes", "Trabajo" o "Texto personalizado"
  final DifficultyLevel? level; // null cuando viene de un texto pegado por el usuario
  final String? translationEs; // null cuando no hay traducción disponible
  final String? grammarNote;

  const DictationSentence({
    required this.id,
    required this.text,
    required this.topic,
    this.level,
    this.translationEs,
    this.grammarNote,
  });
}

extension DifficultyLevelLabel on DifficultyLevel {
  String get label {
    switch (this) {
      case DifficultyLevel.a1:
        return 'A1';
      case DifficultyLevel.a2:
        return 'A2';
      case DifficultyLevel.b1:
        return 'B1';
      case DifficultyLevel.b2:
        return 'B2';
      case DifficultyLevel.c1:
        return 'C1';
      case DifficultyLevel.c2:
        return 'C2';
    }
  }
}
