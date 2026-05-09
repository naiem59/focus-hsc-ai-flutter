import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/study_routine.dart';
import '../services/local_storage_service.dart';

final routineProvider =
    StateNotifierProvider<RoutineNotifier, List<StudyRoutineTask>>((ref) {
  return RoutineNotifier(ref.watch(localStorageServiceProvider));
});

final localStorageServiceProvider = Provider((ref) {
  return LocalStorageService();
});

// Today's routine provider
final todayRoutineProvider =
    FutureProvider<List<StudyRoutineTask>>((ref) async {
  final notifier = ref.watch(routineProvider.notifier);
  return notifier.getTodayRoutine();
});

// Routine stats provider
final routineStatsProvider = Provider<RoutineStats>((ref) {
  final tasks = ref.watch(routineProvider);
  return RoutineStats.fromTasks(tasks);
});

class RoutineNotifier extends StateNotifier<List<StudyRoutineTask>> {
  final LocalStorageService _storageService;
  final Logger _logger = Logger();

  RoutineNotifier(this._storageService) : super([]);

  Future<void> loadTodayRoutine() async {
    try {
      final tasks = _storageService.getRoutineTasksForDate(DateTime.now());
      state = tasks;
      _logger.d('Loaded ${tasks.length} routine tasks for today');
    } catch (e) {
      _logger.e('Error loading routine tasks: $e');
    }
  }

  Future<List<StudyRoutineTask>> getTodayRoutine() async {
    try {
      return _storageService.getRoutineTasksForDate(DateTime.now());
    } catch (e) {
      _logger.e('Error getting today routine: $e');
      return [];
    }
  }

  Future<void> addTask(StudyRoutineTask task) async {
    try {
      await _storageService.saveRoutineTask(task);
      state = [...state, task];
      _logger.d('Task added: ${task.title}');
    } catch (e) {
      _logger.e('Error adding task: $e');
    }
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    try {
      final index = state.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        state[index].markAsCompleted();
        await _storageService.saveRoutineTask(state[index]);
        state = [...state];
        _logger.d('Task marked as completed: $taskId');
      }
    } catch (e) {
      _logger.e('Error marking task as completed: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _storageService.deleteRoutineTask(taskId);
      state = state.where((t) => t.id != taskId).toList();
      _logger.d('Task deleted: $taskId');
    } catch (e) {
      _logger.e('Error deleting task: $e');
    }
  }

  Future<void> generateDailyRoutine() async {
    try {
      // This would typically call an AI service to generate routine
      // For now, just log
      _logger.d('Daily routine generated');
    } catch (e) {
      _logger.e('Error generating daily routine: $e');
    }
  }
}

class RoutineStats {
  final int totalTasks;
  final int completedTasks;
  final int totalDuration;
  final int remainingDuration;

  RoutineStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.totalDuration,
    required this.remainingDuration,
  });

  double getCompletionPercentage() {
    if (totalTasks == 0) return 0;
    return (completedTasks / totalTasks) * 100;
  }

  factory RoutineStats.fromTasks(List<StudyRoutineTask> tasks) {
    final totalDuration = tasks.fold<int>(0, (sum, task) => sum + task.duration);
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final remainingDuration =
        tasks.where((t) => !t.isCompleted).fold<int>(0, (sum, task) => sum + task.duration);

    return RoutineStats(
      totalTasks: tasks.length,
      completedTasks: completedTasks,
      totalDuration: totalDuration,
      remainingDuration: remainingDuration,
    );
  }
}
