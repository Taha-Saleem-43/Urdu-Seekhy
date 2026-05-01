import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/urdu_word.dart';
import '../providers/app_provider.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mic_recorder_widget.dart';
import '../widgets/professor_avatar.dart';

/// Generic lesson screen for any word category.
///
/// This screen now uses the `words` passed in by the route instead of trying
/// to infer content from a title string or load missing image assets.
class CategoryLessonScreen extends StatefulWidget {
  final String title;
  final String emoji;
  final List<UrduWord> words;
  final Color accentColor;

  const CategoryLessonScreen({
    super.key,
    required this.title,
    required this.emoji,
    required this.words,
    required this.accentColor,
  });

  @override
  State<CategoryLessonScreen> createState() => _CategoryLessonScreenState();
}

class _CategoryLessonScreenState extends State<CategoryLessonScreen> {
  AvatarEmotion _emotion = AvatarEmotion.happy;
  final Map<int, double> _scores = {};

  Future<void> _speak(UrduWord word) async {
    setState(() => _emotion = AvatarEmotion.speaking);
    await TtsService.instance.speak('${word.urdu}۔ ${word.english}');
    if (mounted) setState(() => _emotion = AvatarEmotion.happy);
  }

  void _openMic(int index, UrduWord word) {
    unawaited(MicRecorderWidget.show(
      context,
      targetText: word.urdu,
      targetRoman: word.target,
      onScore: (score, _) {
        final provider = context.read<AppProvider>();
        provider.recordResult(word.urdu, score);

        setState(() {
          _scores[index] = score;
          _emotion = score >= 70 ? AvatarEmotion.happy : AvatarEmotion.sad;
        });

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                score >= 70
                    ? 'شاباش! ${score.toInt()}% درست'
                    : 'دوبارہ کوشش کریں۔ اسکور: ${score.toInt()}%',
                style: const TextStyle(fontFamily: 'NotoNastaliqUrdu'),
              ),
            ),
            backgroundColor:
                score >= 70 ? Colors.green.shade600 : Colors.red.shade600,
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.words;

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'NotoNastaliqUrdu',
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: widget.accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.accentColor,
                  widget.accentColor.withValues(alpha: 0.75),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                ProfessorAvatar(emotion: _emotion, size: 92),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    '${widget.emoji}  ${widget.title}',
                    style: const TextStyle(
                      fontFamily: 'NotoNastaliqUrdu',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: words.isEmpty
                ? Center(
                    child: Text(
                      'اس زمرے کے لیے کوئی لفظ موجود نہیں',
                      style: TextStyle(
                        fontFamily: 'NotoNastaliqUrdu',
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      final score = _scores[index];
                      final scoreColor = score == null
                          ? Colors.grey
                          : score >= 70
                              ? Colors.green
                              : score >= 50
                                  ? Colors.orange
                                  : Colors.red;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: widget.accentColor
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: widget.accentColor
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    word.emoji,
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        word.urdu,
                                        style: const TextStyle(
                                          fontFamily: 'NotoNastaliqUrdu',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.navy,
                                        ),
                                      ),
                                      Text(
                                        word.english,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        word.roman,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _speak(word),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: widget.accentColor
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        '🔊',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _openMic(index, word),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.purple
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        '🎤',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  if (score != null) ...[
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: score / 100,
                                            strokeWidth: 3,
                                            backgroundColor: scoreColor
                                                .withValues(alpha: 0.2),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              scoreColor,
                                            ),
                                          ),
                                          Text(
                                            '${score.toInt()}',
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: scoreColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
