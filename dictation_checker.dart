/// Resultado de comparar una palabra escrita por el usuario contra
/// la oración correcta.
enum WordStatus { correct, incorrect, missing, extra }

class WordResult {
  final String word;
  final WordStatus status;
  const WordResult(this.word, this.status);
}

class DictationResult {
  final List<WordResult> words;
  final double accuracy; // 0.0–1.0
  final String correctSentence;

  const DictationResult({
    required this.words,
    required this.accuracy,
    required this.correctSentence,
  });
}

/// Compara lo que el usuario escribió contra la oración correcta,
/// palabra por palabra, e indica errores, omisiones y palabras
/// agregadas de más.
///
/// Es una comparación simple basada en un algoritmo tipo diff (LCS).
/// Suficiente para dictados cortos; para oraciones largas se podría
/// mejorar con una librería de diff más robusta.
class DictationChecker {
  static DictationResult check(String userInput, String correctSentence) {
    final userWords = _tokenize(userInput);
    final correctWords = _tokenize(correctSentence);

    final lcs = _longestCommonSubsequence(userWords, correctWords);

    final results = <WordResult>[];
    int ui = 0, ci = 0, li = 0;

    while (ui < userWords.length || ci < correctWords.length) {
      final matchNext = li < lcs.length &&
          ui < userWords.length &&
          ci < correctWords.length &&
          userWords[ui] == lcs[li] &&
          correctWords[ci] == lcs[li];

      if (matchNext) {
        results.add(WordResult(correctWords[ci], WordStatus.correct));
        ui++;
        ci++;
        li++;
      } else if (ci < correctWords.length &&
          (li >= lcs.length || correctWords[ci] != lcs[li])) {
        // Palabra correcta que el usuario no escribió (omitida)
        // o que escribió mal en esa posición.
        if (ui < userWords.length &&
            (li >= lcs.length || userWords[ui] != lcs[li])) {
          results.add(WordResult(userWords[ui], WordStatus.incorrect));
          ui++;
        }
        results.add(WordResult(correctWords[ci], WordStatus.missing));
        ci++;
      } else if (ui < userWords.length) {
        // Palabra de más que el usuario escribió y no está en la correcta.
        results.add(WordResult(userWords[ui], WordStatus.extra));
        ui++;
      } else {
        ci++;
      }
    }

    final correctCount =
        results.where((r) => r.status == WordStatus.correct).length;
    final accuracy =
        correctWords.isEmpty ? 0.0 : correctCount / correctWords.length;

    return DictationResult(
      words: results,
      accuracy: accuracy,
      correctSentence: correctSentence,
    );
  }

  static List<String> _tokenize(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\x27]'), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  static List<String> _longestCommonSubsequence(
      List<String> a, List<String> b) {
    final m = a.length, n = b.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
          dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
        }
      }
    }

    final result = <String>[];
    int i = m, j = n;
    while (i > 0 && j > 0) {
      if (a[i - 1] == b[j - 1]) {
        result.add(a[i - 1]);
        i--;
        j--;
      } else if (dp[i - 1][j] >= dp[i][j - 1]) {
        i--;
      } else {
        j--;
      }
    }
    return result.reversed.toList();
  }
}
