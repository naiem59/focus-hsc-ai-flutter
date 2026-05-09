import 'package:hive/hive.dart';

part 'weak_topic.g.dart';

@HiveType(typeId: 2)
class WeakTopic extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late String chapter;

  @HiveField(3)
  late int totalQuestionsAnswered;

  @HiveField(4)
  late int wrongAnswersCount;

  @HiveField(5)
  late DateTime lastAttemptDate;

  @HiveField(6)
  late double accuracyPercentage;

  @HiveField(7)
  late int priority; // 1 (highest) to 5 (lowest)

  WeakTopic({
    required this.id,
    required this.subject,
    required this.chapter,
    this.totalQuestionsAnswered = 0,
    this.wrongAnswersCount = 0,
    required this.lastAttemptDate,
    this.accuracyPercentage = 0.0,
    this.priority = 3,
  });

  void updateAccuracy() {
    if (totalQuestionsAnswered > 0) {
      accuracyPercentage =
          ((totalQuestionsAnswered - wrongAnswersCount) / totalQuestionsAnswered) *
              100;
    }
  }

  void updatePriority() {
    // Calculate priority based on accuracy
    if (accuracyPercentage >= 80) {
      priority = 5; // Low priority
    } else if (accuracyPercentage >= 60) {
      priority = 3; // Medium priority
    } else {
      priority = 1; // High priority
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'chapter': chapter,
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'wrongAnswersCount': wrongAnswersCount,
      'lastAttemptDate': lastAttemptDate.toIso8601String(),
      'accuracyPercentage': accuracyPercentage,
      'priority': priority,
    };
  }

  factory WeakTopic.fromJson(Map<String, dynamic> json) {
    return WeakTopic(
      id: json['id'],
      subject: json['subject'],
      chapter: json['chapter'],
      totalQuestionsAnswered: json['totalQuestionsAnswered'] ?? 0,
      wrongAnswersCount: json['wrongAnswersCount'] ?? 0,
      lastAttemptDate: DateTime.parse(json['lastAttemptDate']),
      accuracyPercentage: (json['accuracyPercentage'] as num?)?.toDouble() ?? 0.0,
      priority: json['priority'] ?? 3,
    );
  }
}
