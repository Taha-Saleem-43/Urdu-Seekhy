import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechResult {
  final String transcript;
  final double score;

  const SpeechResult({
    required this.transcript,
    required this.score,
  });
}

class SpeechService {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;
  String _selectedLocale = 'en_US';

  String _lastWords = '';

  Future<bool> init() async {
    _available = await _speech.initialize(
      onError: (e) {},
      onStatus: (s) {},
    );
    if (_available) {
      await _selectBestLocale();
    }
    return _available;
  }

  bool get isListening => _speech.isListening;

  Future<SpeechResult> listen({String? expectedText}) async {
    if (!_available) await init();

    _lastWords = '';

    if (!_available) {
      return const SpeechResult(transcript: '', score: 0);
    }

    await _speech.listen(
      localeId: _selectedLocale,
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 2),
      onResult: (result) {
        _lastWords = result.recognizedWords;
      },
    );

    await Future.delayed(const Duration(seconds: 6));

    await _speech.stop();

    final score = _computeScore(_lastWords, expectedText ?? '');

    return SpeechResult(
      transcript: _lastWords,
      score: score,
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }

  Future<void> _selectBestLocale() async {
    try {
      final locales = await _speech.locales();
      final ids = locales.map((l) => l.localeId).toList();
      if (ids.contains('ur_PK')) {
        _selectedLocale = 'ur_PK';
        return;
      }
      final urdu = ids.where((id) => id.toLowerCase().startsWith('ur')).toList();
      if (urdu.isNotEmpty) {
        _selectedLocale = urdu.first;
        return;
      }
      if (ids.contains('en_US')) {
        _selectedLocale = 'en_US';
        return;
      }
      if (ids.isNotEmpty) {
        _selectedLocale = ids.first;
      }
    } catch (_) {
      _selectedLocale = 'en_US';
    }
  }

  double _computeScore(String heard, String expected) {
    if (expected.trim().isEmpty) return 0.5;
    if (heard.trim().isEmpty) return 0.0;

    final h = heard.trim().toLowerCase();
    final e = expected.trim().toLowerCase();

    if (h == e) return 1.0;

    final hWords = h.split(' ');
    final eWords = e.split(' ');

    int matchCount = 0;

    for (final w in hWords) {
      if (eWords.contains(w)) {
        matchCount++;
      }
    }

    return (matchCount / eWords.length).clamp(0.0, 1.0);
  }
}