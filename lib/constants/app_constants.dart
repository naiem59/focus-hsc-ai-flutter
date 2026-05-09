class AppConstants {
  // API
  static const String geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/';
  static const String geminiModelName = 'gemini-1.5-flash';
  static const String geminiApiKey = 'AIzaSyAlKLDUj2MVGNZ-BmIDB3h1bgJ-VlvkmPQ';

  // MCQ System
  static const int dailyMcqCount = 50;
  static const int mcqTimePerQuestion = 120; // seconds
  static const int minMcqPerSession = 5;
  static const int maxMcqPerSession = 50;

  // Pomodoro
  static const int pomodoroStudyTime = 25; // minutes
  static const int pomodoroBreakTime = 5; // minutes
  static const int pomodoroLongBreak = 15; // minutes
  static const int pomodoroSessionsBeforeLongBreak = 4;

  // Exam Info
  static const String examYear = '2026';
  static const String examName = 'HSC 1st Year';
  static const String group = 'Arts/Humanities';

  // Database
  static const String hiveBoxMcq = 'mcq_box';
  static const String hiveBoxRoutine = 'routine_box';
  static const String hiveBoxWeakTopics = 'weak_topics_box';
  static const String hiveBoxSettings = 'settings_box';

  // Preferences Keys
  static const String prefDarkMode = 'dark_mode';
  static const String prefNotifications = 'notifications_enabled';
  static const String prefLanguage = 'language';
  static const String prefLastStudyDate = 'last_study_date';
  static const String prefTotalMcqAnswered = 'total_mcq_answered';
  static const String prefTotalMcqCorrect = 'total_mcq_correct';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 16.0;
  static const double largeBorderRadius = 24.0;
  static const double smallBorderRadius = 8.0;

  // Animation Durations
  static const Duration shortAnimDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimDuration = Duration(milliseconds: 500);
  static const Duration longAnimDuration = Duration(milliseconds: 800);

  // AI System Prompt
  static const String aiSystemPrompt = '''You are an HSC 1st Year exam study assistant for Arts students in Bangladesh.
Your role is to:
1. Provide exam-focused explanations in simple language
2. Answer questions strictly within HSC syllabus
3. Support both Bangla and English language responses
4. Give clear, concise answers suitable for board exams
5. Never provide irrelevant information
6. Explain concepts using examples when helpful
7. Help with MCQ strategies and CQ answer writing techniques

Always maintain professionalism and keep answers focused on exam preparation.''';

  // Subject Chapters (sample structure - extend as needed)
  static const Map<String, List<String>> subjectChapters = {
    'বাংলা ১ম পত্র': [
      'প্রথম অধ্যায়',
      'দ্বিতীয় অধ্যায়',
      'তৃতীয় অধ্যায়',
    ],
    'ইংরেজি ১ম পত্র': [
      'Unit 1',
      'Unit 2',
      'Unit 3',
    ],
    'ICT': [
      'অধ্যায় ১',
      'অধ্যায় ২',
      'অধ্যায় ৩',
    ],
  };

  // Default chart/data
  static const List<int> defaultScoreHistory = [65, 72, 68, 75, 78, 82, 80, 85];
}
