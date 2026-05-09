import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/weak_topic.dart';
import '../services/local_storage_service.dart';

final weakTopicsProvider =
    StateNotifierProvider<WeakTopicsNotifier, List<WeakTopic>>((ref) {
  return WeakTopicsNotifier(ref.watch(localStorageServiceProviderWeak));
});

final localStorageServiceProviderWeak = Provider((ref) {
  return LocalStorageService();
});

// Top weak topics provider (top 5)
final topWeakTopicsProvider = Provider<List<WeakTopic>>((ref) {
  final topics = ref.watch(weakTopicsProvider);
  return topics.where((t) => t.priority <= 2).toList()..sort((a, b) => a.priority.compareTo(b.priority));
});

// Weak topics by subject
final weakTopicsBySubjectProvider =
    FutureProvider.family<List<WeakTopic>, String>((ref, subject) async {
  final notifier = ref.watch(weakTopicsProvider.notifier);
  return notifier.getTopicsBySubject(subject);
});

class WeakTopicsNotifier extends StateNotifier<List<WeakTopic>> {
  final LocalStorageService _storageService;
  final Logger _logger = Logger();

  WeakTopicsNotifier(this._storageService) : super([]);

  Future<void> loadWeakTopics() async {
    try {
      final topics = _storageService.getAllWeakTopics();
      state = topics;
      _logger.d('Loaded ${topics.length} weak topics');
    } catch (e) {
      _logger.e('Error loading weak topics: $e');
    }
  }

  Future<void> updateWeakTopic(WeakTopic topic) async {
    try {
      topic.updateAccuracy();
      topic.updatePriority();
      await _storageService.saveWeakTopic(topic);

      final index = state.indexWhere((t) => t.id == topic.id);
      if (index != -1) {
        state[index] = topic;
        state = [...state];
      } else {
        state = [...state, topic];
      }
      _logger.d('Weak topic updated: ${topic.subject} - ${topic.chapter}');
    } catch (e) {
      _logger.e('Error updating weak topic: $e');
    }
  }

  Future<List<WeakTopic>> getTopicsBySubject(String subject) async {
    try {
      return _storageService.getWeakTopicsBySubject(subject);
    } catch (e) {
      _logger.e('Error getting weak topics by subject: $e');
      return [];
    }
  }

  Future<void> trackWrongAnswer(String subject, String chapter) async {
    try {
      final topics = _storageService.getWeakTopicsBySubject(subject);
      WeakTopic? topic =
          topics.firstWhere((t) => t.chapter == chapter, orElse: () => WeakTopic(
            id: '$subject-$chapter',
            subject: subject,
            chapter: chapter,
            lastAttemptDate: DateTime.now(),
          ));

      topic.totalQuestionsAnswered++;
      topic.wrongAnswersCount++;
      await updateWeakTopic(topic);
      _logger.d('Tracked wrong answer for: $subject - $chapter');
    } catch (e) {
      _logger.e('Error tracking wrong answer: $e');
    }
  }

  Future<void> trackCorrectAnswer(String subject, String chapter) async {
    try {
      final topics = _storageService.getWeakTopicsBySubject(subject);
      WeakTopic? topic = topics.firstWhere(
        (t) => t.chapter == chapter,
        orElse: () => WeakTopic(
          id: '$subject-$chapter',
          subject: subject,
          chapter: chapter,
          lastAttemptDate: DateTime.now(),
        ),
      );

      topic.totalQuestionsAnswered++;
      await updateWeakTopic(topic);
      _logger.d('Tracked correct answer for: $subject - $chapter');
    } catch (e) {
      _logger.e('Error tracking correct answer: $e');
    }
  }
}
