class CQQuestion {
  final String id;
  final String subject;
  final String question;
  final String shortAnswer;
  final String fullAnswer;
  final List<String> keyPoints;
  final DateTime createdAt;

  CQQuestion({
    required this.id,
    required this.subject,
    required this.question,
    required this.shortAnswer,
    required this.fullAnswer,
    required this.keyPoints,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'question': question,
      'shortAnswer': shortAnswer,
      'fullAnswer': fullAnswer,
      'keyPoints': keyPoints,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CQQuestion.fromJson(Map<String, dynamic> json) {
    return CQQuestion(
      id: json['id'],
      subject: json['subject'],
      question: json['question'],
      shortAnswer: json['shortAnswer'],
      fullAnswer: json['fullAnswer'],
      keyPoints: List<String>.from(json['keyPoints']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
