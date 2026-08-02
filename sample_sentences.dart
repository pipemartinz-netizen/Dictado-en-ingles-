import '../models/sentence.dart';

/// Banco de frases de ejemplo para el prototipo.
/// En la versión final esto vendría de una base de datos local
/// (con cientos de categorías) sincronizada desde un panel de admin.
final List<DictationSentence> sampleSentences = [
  const DictationSentence(
    id: '1',
    text: 'I am looking for a new job.',
    topic: 'Trabajo',
    level: DifficultyLevel.a2,
    translationEs: 'Estoy buscando un nuevo trabajo.',
    grammarNote: 'Presente continuo: "am" + verbo + "-ing".',
  ),
  const DictationSentence(
    id: '2',
    text: 'She is a software engineer.',
    topic: 'Trabajo',
    level: DifficultyLevel.a1,
    translationEs: 'Ella es ingeniera de software.',
    grammarNote: 'Verbo "to be" en presente: "is".',
  ),
  const DictationSentence(
    id: '3',
    text: 'We are traveling to Spain next month.',
    topic: 'Viajes',
    level: DifficultyLevel.b1,
    translationEs: 'Viajaremos a España el próximo mes.',
    grammarNote: 'Presente continuo con valor de futuro planeado.',
  ),
  const DictationSentence(
    id: '4',
    text: 'Can you recommend a good restaurant near here?',
    topic: 'Restaurantes',
    level: DifficultyLevel.a2,
    translationEs: '¿Puedes recomendar un buen restaurante cerca de aquí?',
  ),
  const DictationSentence(
    id: '5',
    text: 'I have three years of experience in industrial engineering.',
    topic: 'Entrevistas laborales',
    level: DifficultyLevel.b1,
    translationEs: 'Tengo tres años de experiencia en ingeniería industrial.',
  ),
];
