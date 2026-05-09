import 'package:hive/hive.dart';

part 'study_routine.g.dart';

@HiveType(typeId: 1)
class StudyRoutineTask extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String subject;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late int duration; // in minutes

  @HiveField(5)
  late bool isCompleted;

  @HiveField(6)
  late DateTime createdDate;

  @HiveField(7)
  late DateTime? completedDate;

  @HiveField(8)
  late int priority; // 1 (high) to 3 (low)

  StudyRoutineTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.duration,
    this.isCompleted = false,
    required this.createdDate,
    this.completedDate,
    this.priority = 2,
  });

  void markAsCompleted() {
    isCompleted = true;
    completedDate = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'duration': duration,
      'isCompleted': isCompleted,
      'createdDate': createdDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'priority': priority,
    };
  }

  factory StudyRoutineTask.fromJson(Map<String, dynamic> json) {
    return StudyRoutineTask(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      description: json['description'],
      duration: json['duration'],
      isCompleted: json['isCompleted'] ?? false,
      createdDate: DateTime.parse(json['createdDate']),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      priority: json['priority'] ?? 2,
    );
  }
}

class DailyRoutine {
  final DateTime date;
  final List<StudyRoutineTask> tasks;
  final int totalDuration;

  DailyRoutine({
    required this.date,
    required this.tasks,
  }) : totalDuration = tasks.fold(0, (sum, task) => sum + task.duration);

  int getCompletedTasksCount() => tasks.where((t) => t.isCompleted).length;

  double getCompletionPercentage() {
    if (tasks.isEmpty) return 0;
    return (getCompletedTasksCount() / tasks.length) * 100;
  }

  int getRemainingDuration() {
    return tasks
        .where((t) => !t.isCompleted)
        .fold(0, (sum, task) => sum + task.duration);
  }
}
