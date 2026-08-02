import 'package:flutter/material.dart';
import '../services/dictation_checker.dart';

class ResultView extends StatelessWidget {
  final DictationResult result;

  const ResultView({super.key, required this.result});

  Color _colorFor(WordStatus status, BuildContext context) {
    switch (status) {
      case WordStatus.correct:
        return const Color(0xFF2E7D32); // verde
      case WordStatus.incorrect:
        return const Color(0xFFC62828); // rojo
      case WordStatus.missing:
        return const Color(0xFFF9A825); // ámbar (omitida)
      case WordStatus.extra:
        return const Color(0xFF6A1B9A); // morado (agregada de más)
    }
  }

  String _labelFor(WordStatus status) {
    switch (status) {
      case WordStatus.correct:
        return 'correcta';
      case WordStatus.incorrect:
        return 'incorrecta';
      case WordStatus.missing:
        return 'omitida';
      case WordStatus.extra:
        return 'de más';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accuracyPct = (result.accuracy * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$accuracyPct%',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Text('de precisión'),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 6,
          runSpacing: 8,
          children: result.words.map((w) {
            final isStrike = w.status == WordStatus.missing ||
                w.status == WordStatus.extra;
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _colorFor(w.status, context).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _colorFor(w.status, context).withOpacity(0.4),
                ),
              ),
              child: Text(
                w.word,
                style: TextStyle(
                  color: _colorFor(w.status, context),
                  fontWeight: FontWeight.w600,
                  decoration:
                      isStrike ? TextDecoration.lineThrough : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        _Legend(colorFor: (s) => _colorFor(s, context), labelFor: _labelFor),
        const SizedBox(height: 20),
        Text(
          'Respuesta correcta:',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        Text(
          result.correctSentence,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color Function(WordStatus) colorFor;
  final String Function(WordStatus) labelFor;

  const _Legend({required this.colorFor, required this.labelFor});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: WordStatus.values.map((s) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(color: colorFor(s), shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(labelFor(s), style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      }).toList(),
    );
  }
}
