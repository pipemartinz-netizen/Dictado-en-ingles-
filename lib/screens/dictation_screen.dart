import 'package:flutter/material.dart';
import '../models/sentence.dart';
import '../services/dictation_checker.dart';
import '../services/tts_service.dart';
import '../services/speech_service.dart';
import '../widgets/result_view.dart';

class DictationScreen extends StatefulWidget {
  final List<DictationSentence> sentences;

  const DictationScreen({super.key, required this.sentences});

  @override
  State<DictationScreen> createState() => _DictationScreenState();
}

class _DictationScreenState extends State<DictationScreen> {
  final TtsService _tts = TtsService();
  final SpeechService _speech = SpeechService();
  final TextEditingController _inputController = TextEditingController();

  static const List<double> speeds = [
    0.25, 0.50, 0.75, 1.0, 1.10, 1.25, 1.50, 1.75, 2.0,
  ];

  double _speed = 1.0;
  int _currentIndex = 0;
  DictationResult? _result;
  String _accent = 'US';

  String? _spokenText;
  bool _isListening = false;

  DictationSentence get _current => widget.sentences[_currentIndex];
  bool get _isLastSentence => _currentIndex >= widget.sentences.length - 1;

  @override
  void dispose() {
    _inputController.dispose();
    _tts.stop();
    _speech.stop();
    super.dispose();
  }

  Future<void> _playSentence() async {
    await _tts.speak(_current.text, speed: _speed);
  }

  Future<void> _changeAccent(String accent) async {
    setState(() => _accent = accent);
    await _tts.setAccent(accent);
  }

  void _checkAnswer() {
    final result =
        DictationChecker.check(_inputController.text, _current.text);
    setState(() => _result = result);
  }

  void _nextSentence() {
    if (_isLastSentence) return;
    setState(() {
      _currentIndex++;
      _inputController.clear();
      _result = null;
      _spokenText = null;
    });
  }

  Future<void> _togglePronunciationPractice() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }
    setState(() {
      _isListening = true;
      _spokenText = null;
    });
    await _speech.listen(
      accent: _accent,
      onResult: (text, isFinal) {
        setState(() {
          _spokenText = text;
          if (isFinal) _isListening = false;
        });
      },
    );
  }

  Future<void> _openVoicePicker() async {
    final voices = await _tts.getEnglishVoices();
    if (!mounted) return;
    if (voices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron voces en inglés en este celular.')),
      );
      return;
    }
    final seen = <String>{};
    final unique = voices.where((v) => seen.add(v['name'] ?? '')).toList();

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Elegí una voz', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...unique.map((v) => ListTile(
                    title: Text(v['name'] ?? ''),
                    subtitle: Text(v['locale'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () async {
                        await _tts.setChosenVoice(v['name']!, v['locale']!);
                        await _tts.speak(_current.text, speed: _speed);
                      },
                    ),
                    onTap: () async {
                      await _tts.setChosenVoice(v['name']!, v['locale']!);
                      if (mounted) Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dictado · ${_current.topic}'
          '${_current.level != null ? ' · ${_current.level!.label}' : ''}'
          ' (${_currentIndex + 1}/${widget.sentences.length})',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'US', label: Text('🇺🇸 Americano')),
                          ButtonSegment(value: 'GB', label: Text('🇬🇧 Británico')),
                        ],
                        selected: {_accent},
                        onSelectionChanged: (s) => _changeAccent(s.first),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _openVoicePicker,
                        icon: const Icon(Icons.record_voice_over),
                        label: const Text('Elegir voz'),
                      ),
                      const SizedBox(height: 8),
                      IconButton.filled(
                        iconSize: 36,
                        padding: const EdgeInsets.all(20),
                        onPressed: _playSentence,
                        icon: const Icon(Icons.volume_up),
                      ),
                      const SizedBox(height: 12),
                      const Text('Toca para escuchar la oración'),
                      const SizedBox(height: 16),
                      DropdownButton<double>(
                        value: _speed,
                        items: speeds
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text('${s}x'),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _speed = v ?? 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _inputController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Escribe lo que escuchaste',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _checkAnswer,
                      child: const Text('Revisar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLastSentence ? null : _nextSentence,
                      child: Text(
                        _isLastSentence ? 'Última oración' : 'Siguiente',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Práctica de pronunciación',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _togglePronunciationPractice,
                        icon: Icon(_isListening ? Icons.stop : Icons.mic),
                        label: Text(_isListening
                            ? 'Escuchando... toca para parar'
                            : 'Repite conmigo'),
                      ),
                      if (_spokenText != null) ...[
                        const SizedBox(height: 12),
                        const Text('Lo que se entendió:'),
                        Text(_spokenText!,
                            style: const TextStyle(fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        ResultView(
                          result: DictationChecker.check(
                              _spokenText!, _current.text),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_result != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                ResultView(result: _result!),
                if (_current.translationEs != null ||
                    _current.grammarNote != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_current.translationEs != null) ...[
                            Text('Traducción',
                                style: Theme.of(context).textTheme.labelLarge),
                            Text(_current.translationEs!),
                          ],
                          if (_current.grammarNote != null) ...[
                            const SizedBox(height: 8),
                            Text('Gramática',
                                style: Theme.of(context).textTheme.labelLarge),
                            Text(_current.grammarNote!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
