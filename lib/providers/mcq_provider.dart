import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/mcq_question.dart';
import '../services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

final localStorageProvider = Provider((ref) {
  return LocalStorageService();
});

// MCQ questions provider
final mcqQuestionsProvider =
    StateNotifierProvider<MCQNotifier, List<MCQQuestion>>((ref) {
  return MCQNotifier(ref.watch(localStorageProvider));
});

// Current MCQ question index
final currentMCQIndexProvider = StateProvider<int>((ref) => 0);

// Selected subject provider
final selectedMCQSubjectProvider = StateProvider<String>((ref) => '');

// Selected chapter provider
final selectedMCQChapterProvider = StateProvider<String>((ref) => '');

// MCQ session stats
final mcqSessionStatsProvider = StateProvider<MCQSessionStats>((ref) {
  return MCQSessionStats();
});

// Wrong MCQs provider
final wrongMCQsProvider =
    StateNotifierProvider<WrongMCQNotifier, List<MCQQuestion>>((ref) {
  return WrongMCQNotifier(ref.watch(localStorageProvider));
});

class MCQNotifier extends StateNotifier<List<MCQQuestion>> {
  final LocalStorageService _storageService;
  final Logger _logger = Logger();

  MCQNotifier(this._storageService) : super([]);

  Future<void> loadMCQsBySubjectAndChapter(
      String subject, String chapter) async {
    try {
      final questions = _storageService.getMCQQuestionsByChapter(subject, chapter);
      state = questions;
      _logger.d('Loaded ${questions.length} MCQ questions');
    } catch (e) {
      _logger.e('Error loading MCQ questions: $e');
    }
  }

  Future<void> loadAllMCQs() async {
    try {
      final questions = _storageService.getAllMCQQuestions();
      state = questions;
      _logger.d('Loaded ${questions.length} MCQ questions');
    } catch (e) {
      _logger.e('Error loading all MCQ questions: $e');
    }
  }

  Future<void> answerQuestion(int index, int selectedOptionIndex) async {
    try {
      if (index >= 0 && index < state.length) {
        final question = state[index];
        question.userAnswerIndex = selectedOptionIndex;
        question.answeredAt = DateTime.now();
        await _storageService.saveMCQQuestion(question);

        // Update state
        state = [...state];
        _logger.d('Question answered at index $index');
      }
    } catch (e) {
      _logger.e('Error answering question: $e');
    }
  }

  Future<void> generateSampleMCQs(String subject, String chapter) async {
    try {
      final sampleQuestions = <MCQQuestion>[
        MCQQuestion(
          id: const Uuid().v4(),
          subject: subject,
          chapter: chapter,
          question: 'এই একটি নমুনা প্রশ্ন। সঠিক উত্তর কী?',
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
          correctAnswerIndex: 1,
          difficulty: 'Medium',
          explanation: 'এটি B কারণ... (ব্যাখ্যা এখানে আসবে)',
        ),
      ];

      await _storageService.saveMCQQuestions(sampleQuestions);
      state = sampleQuestions;
      _logger.d('Sample MCQs generated');
    } catch (e) {
      _logger.e('Error generating sample MCQs: $e');
    }
  }

  void clearQuestions() {
    state = [];
  }
}

class WrongMCQNotifier extends StateNotifier<List<MCQQuestion>> {
  final LocalStorageService _storageService;
  final Logger _logger = Logger();

  WrongMCQNotifier(this._storageService) : super([]);

  Future<void> loadWrongMCQs() async {
    try {
      final wrongQuestions = _storageService.getWrongMCQQuestions();
      state = wrongQuestions;
      _logger.d('Loaded ${wrongQuestions.length} wrong MCQ questions');
    } catch (e) {
      _logger.e('Error loading wrong MCQs: $e');
    }
  }
}

class MCQSessionStats {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final Duration timeTaken;

  MCQSessionStats({
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.timeTaken = const Duration(),
  });

  double getAccuracy() {
    if (totalQuestions == 0) return 0;
    return (correctAnswers / totalQuestions) * 100;
  }

  MCQSessionStats copyWith({
    int? totalQuestions,
    int? correctAnswers,
    int? wrongAnswers,
    Duration? timeTaken,
  }) {
    return MCQSessionStats(
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      timeTaken: timeTaken ?? this.timeTaken,
    );
  }
}
