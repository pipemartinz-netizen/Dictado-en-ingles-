import 'package:flutter/material.dart';
import '../data/sample_sentences.dart';
import 'custom_text_screen.dart';
import 'dictation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dictado Inglés')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.headphones, size: 72),
              const SizedBox(height: 12),
              Text(
                'Entrena tu oído y tu escritura en inglés',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text('Pegar mi propio texto'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomTextScreen()),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text('Probar con frases de ejemplo'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DictationScreen(sentences: sampleSentences),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
