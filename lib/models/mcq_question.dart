import 'package:hive/hive.dart';

part 'mcq_question.g.dart';

@HiveType(typeId: 0)
class MCQQuestion extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late String chapter;

  @HiveField(3)
  late String question;

  @HiveField(4)
  late List<String> options;

  @HiveField(5)
  late int correctAnswerIndex;

  @HiveField(6)
  late String? explanation;

  @HiveField(7)
  late String difficulty; // Easy, Medium, Hard

  @HiveField(8)
  late int? userAnswerIndex;

  @HiveField(9)
  late DateTime? answeredAt;

  @HiveField(10)
  late bool isReviewedWrong;

  MCQQuestion({
    required this.id,
    required this.subject,
    required this.chapter,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.difficulty = 'Medium',
    this.userAnswerIndex,
    this.answeredAt,
    this.isReviewedWrong = false,
  });

  bool isAnsweredCorrectly() {
    return userAnswerIndex == correctAnswerIndex;
  }

  bool isAnswered() {
    return userAnswerIndex != null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'chapter': chapter,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'difficulty': difficulty,
      'userAnswerIndex': userAnswerIndex,
      'answeredAt': answeredAt?.toIso8601String(),
      'isReviewedWrong': isReviewedWrong,
    };
  }

  factory MCQQuestion.fromJson(Map<String, dynamic> json) {
    return MCQQuestion(
      id: json['id'],
      subject: json['subject'],
      chapter: json['chapter'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      difficulty: json['difficulty'] ?? 'Medium',
      userAnswerIndex: json['userAnswerIndex'],
      answeredAt: json['answeredAt'] != null
          ? DateTime.parse(json['answeredAt'])
          : null,
      isReviewedWrong: json['isReviewedWrong'] ?? false,
    );
  }
}
