import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/mcq_question.dart';
import '../models/study_routine.dart';
import '../models/weak_topic.dart';

class LocalStorageService {
  final Logger _logger = Logger();
  late Box<MCQQuestion> _mcqBox;
  late Box<StudyRoutineTask> _routineBox;
  late Box<WeakTopic> _weakTopicsBox;
  late Box<dynamic> _settingsBox;

  Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(MCQQuestionAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(StudyRoutineTaskAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(WeakTopicAdapter());
      }

      // Open boxes
      _mcqBox = await Hive.openBox<MCQQuestion>(AppConstants.hiveBoxMcq);
      _routineBox =
          await Hive.openBox<StudyRoutineTask>(AppConstants.hiveBoxRoutine);
      _weakTopicsBox =
          await Hive.openBox<WeakTopic>(AppConstants.hiveBoxWeakTopics);
      _settingsBox =
          await Hive.openBox<dynamic>(AppConstants.hiveBoxSettings);

      _logger.i('LocalStorageService initialized successfully');
    } catch (e) {
      _logger.e('Error initializing LocalStorageService: $e');
      rethrow;
    }
  }

  // MCQ Methods
  Future<void> saveMCQQuestion(MCQQuestion question) async {
    try {
      await _mcqBox.put(question.id, question);
      _logger.d('MCQ question saved: ${question.id}');
    } catch (e) {
      _logger.e('Error saving MCQ question: $e');
      rethrow;
    }
  }

  Future<void> saveMCQQuestions(List<MCQQuestion> questions) async {
    try {
      final Map<String, MCQQuestion> data = {};
      for (var q in questions) {
        data[q.id] = q;
      }
      await _mcqBox.putAll(data);
      _logger.d('${questions.length} MCQ questions saved');
    } catch (e) {
      _logger.e('Error saving MCQ questions: $e');
      rethrow;
    }
  }

  Future<MCQQuestion?> getMCQQuestion(String id) async {
    try {
      return _mcqBox.get(id);
    } catch (e) {
      _logger.e('Error getting MCQ question: $e');
      return null;
    }
  }

  List<MCQQuestion> getAllMCQQuestions() {
    try {
      return _mcqBox.values.toList();
    } catch (e) {
      _logger.e('Error getting all MCQ questions: $e');
      return [];
    }
  }

  List<MCQQuestion> getMCQQuestionsBySubject(String subject) {
    try {
      return _mcqBox.values
          .where((q) => q.subject == subject)
          .toList();
    } catch (e) {
      _logger.e('Error getting MCQ questions by subject: $e');
      return [];
    }
  }

  List<MCQQuestion> getMCQQuestionsByChapter(String subject, String chapter) {
    try {
      return _mcqBox.values
          .where((q) => q.subject == subject && q.chapter == chapter)
          .toList();
    } catch (e) {
      _logger.e('Error getting MCQ questions by chapter: $e');
      return [];
    }
  }

  List<MCQQuestion> getWrongMCQQuestions() {
    try {
      return _mcqBox.values
          .where((q) => q.isAnswered() && !q.isAnsweredCorrectly())
          .toList();
    } catch (e) {
      _logger.e('Error getting wrong MCQ questions: $e');
      return [];
    }
  }

  Future<void> deleteMCQQuestion(String id) async {
    try {
      await _mcqBox.delete(id);
      _logger.d('MCQ question deleted: $id');
    } catch (e) {
      _logger.e('Error deleting MCQ question: $e');
      rethrow;
    }
  }

  Future<void> clearAllMCQQuestions() async {
    try {
      await _mcqBox.clear();
      _logger.d('All MCQ questions cleared');
    } catch (e) {
      _logger.e('Error clearing MCQ questions: $e');
      rethrow;
    }
  }

  // Routine Methods
  Future<void> saveRoutineTask(StudyRoutineTask task) async {
    try {
      await _routineBox.put(task.id, task);
      _logger.d('Routine task saved: ${task.id}');
    } catch (e) {
      _logger.e('Error saving routine task: $e');
      rethrow;
    }
  }

  Future<void> saveRoutineTasks(List<StudyRoutineTask> tasks) async {
    try {
      final Map<String, StudyRoutineTask> data = {};
      for (var t in tasks) {
        data[t.id] = t;
      }
      await _routineBox.putAll(data);
      _logger.d('${tasks.length} routine tasks saved');
    } catch (e) {
      _logger.e('Error saving routine tasks: $e');
      rethrow;
    }
  }

  List<StudyRoutineTask> getRoutineTasksForDate(DateTime date) {
    try {
      return _routineBox.values
          .where((t) =>
              t.createdDate.year == date.year &&
              t.createdDate.month == date.month &&
              t.createdDate.day == date.day)
          .toList();
    } catch (e) {
      _logger.e('Error getting routine tasks: $e');
      return [];
    }
  }

  Future<void> deleteRoutineTask(String id) async {
    try {
      await _routineBox.delete(id);
      _logger.d('Routine task deleted: $id');
    } catch (e) {
      _logger.e('Error deleting routine task: $e');
      rethrow;
    }
  }

  // Weak Topics Methods
  Future<void> saveWeakTopic(WeakTopic topic) async {
    try {
      await _weakTopicsBox.put(topic.id, topic);
      _logger.d('Weak topic saved: ${topic.id}');
    } catch (e) {
      _logger.e('Error saving weak topic: $e');
      rethrow;
    }
  }

  List<WeakTopic> getAllWeakTopics() {
    try {
      return _weakTopicsBox.values.toList();
    } catch (e) {
      _logger.e('Error getting weak topics: $e');
      return [];
    }
  }

  List<WeakTopic> getWeakTopicsBySubject(String subject) {
    try {
      return _weakTopicsBox.values
          .where((t) => t.subject == subject)
          .toList();
    } catch (e) {
      _logger.e('Error getting weak topics by subject: $e');
      return [];
    }
  }

  List<WeakTopic> getTopWeakTopics({int limit = 5}) {
    try {
      final topics = _weakTopicsBox.values.toList();
      topics.sort((a, b) => a.priority.compareTo(b.priority));
      return topics.take(limit).toList();
    } catch (e) {
      _logger.e('Error getting top weak topics: $e');
      return [];
    }
  }

  // Settings Methods
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      await _settingsBox.put(key, value);
      _logger.d('Setting saved: $key');
    } catch (e) {
      _logger.e('Error saving setting: $e');
      rethrow;
    }
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    try {
      return _settingsBox.get(key, defaultValue: defaultValue);
    } catch (e) {
      _logger.e('Error getting setting: $e');
      return defaultValue;
    }
  }

  Future<void> closeAllBoxes() async {
    try {
      await Hive.close();
      _logger.i('All Hive boxes closed');
    } catch (e) {
      _logger.e('Error closing Hive boxes: $e');
      rethrow;
    }
  }
}
