import 'package:flutter/material.dart';
import '../models/sentence.dart';
import '../services/text_splitter.dart';
import 'dictation_screen.dart';

class CustomTextScreen extends StatefulWidget {
  const CustomTextScreen({super.key});

  @override
  State<CustomTextScreen> createState() => _CustomTextScreenState();
}

class _CustomTextScreenState extends State<CustomTextScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startDictation() {
    final sentences = TextSplitter.splitIntoSentences(_controller.text);

    if (sentences.isEmpty) {
      setState(() => _error = 'Pega o escribe algún texto en inglés primero.');
      return;
    }

    setState(() => _error = null);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DictationScreen(sentences: sentences),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pegar mi propio texto')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pega cualquier texto en inglés (un artículo, una '
                'transcripción, un correo, lo que sea). Lo dividimos en '
                'oraciones y las convertimos en un dictado.',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Pega aquí tu texto en inglés...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _startDictation,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar dictado con este texto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
