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
