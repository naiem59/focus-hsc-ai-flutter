class UserProgress {
  final DateTime date;
  final int totalMcqAnswered;
  final int correctAnswers;
  final int wrongAnswers;
  final int studyMinutes;
  final List<String> subjectsStudied;

  UserProgress({
    required this.date,
    required this.totalMcqAnswered,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.studyMinutes,
    required this.subjectsStudied,
  });

  double getAccuracy() {
    if (totalMcqAnswered == 0) return 0;
    return (correctAnswers / totalMcqAnswered) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalMcqAnswered': totalMcqAnswered,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'studyMinutes': studyMinutes,
      'subjectsStudied': subjectsStudied,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      date: DateTime.parse(json['date']),
      totalMcqAnswered: json['totalMcqAnswered'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      wrongAnswers: json['wrongAnswers'] ?? 0,
      studyMinutes: json['studyMinutes'] ?? 0,
      subjectsStudied: List<String>.from(json['subjectsStudied'] ?? []),
    );
  }
}
