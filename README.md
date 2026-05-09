# Focus HSC AI - Flutter App Documentation

## Overview

Focus HSC AI is a premium Flutter application designed as an AI-powered study assistant for HSC 1st Year Arts students in Bangladesh preparing for their 2026 exams.

## Project Structure

```
lib/
├── main.dart                    # App entry point and main navigation
├── screens/
│   ├── splash_screen.dart       # Splash/Loading screen
│   ├── home_screen.dart         # Main dashboard
│   ├── chat_screen.dart         # AI chat interface
│   ├── mcq_screen.dart          # MCQ practice
│   ├── cq_helper_screen.dart    # CQ answer generator
│   ├── routine_screen.dart      # Study routine & tasks
│   ├── weak_topics_screen.dart  # Weak topic tracker
│   └── settings_screen.dart     # App settings
├── models/
│   ├── mcq_question.dart        # MCQ data model
│   ├── chat_message.dart        # Chat message model
│   ├── study_routine.dart       # Routine task models
│   ├── weak_topic.dart          # Weak topic tracking
│   ├── user_progress.dart       # User progress tracking
│   └── cq_question.dart         # CQ answer model
├── services/
│   ├── gemini_ai_service.dart   # Gemini API integration
│   ├── local_storage_service.dart # Hive database
│   └── preferences_service.dart  # SharedPreferences
├── providers/
│   ├── chat_provider.dart       # Chat state management
│   ├── mcq_provider.dart        # MCQ state management
│   ├── routine_provider.dart    # Routine state management
│   ├── weak_topics_provider.dart # Weak topics state
│   └── settings_provider.dart   # Settings state
├── widgets/
│   ├── custom_widgets.dart      # Reusable UI components
│   └── feature_widgets.dart     # Feature-specific widgets
├── utils/
│   ├── app_theme.dart           # Theme & typography
│   ├── date_utils.dart          # Date utilities
│   └── validation_utils.dart    # Validation helpers
└── constants/
    ├── app_colors.dart          # Color palette
    ├── app_strings.dart         # UI strings
    └── app_constants.dart       # App configuration
```

## Key Features

### 1. AI Study Chat
- Real-time conversation with Gemini AI
- Subject-specific explanations
- Bangla/English support
- Exam-focused responses

### 2. MCQ Practice System
- Chapter-wise question selection
- Timed exam mode
- Instant feedback with explanations
- Wrong answer tracking
- Revision mode for weak areas

### 3. CQ Answer Helper
- AI-powered answer generation
- Multiple answer formats (Short/Full/Key Points)
- Board exam structured answers

### 4. Study Routine System
- Daily task management
- Exam countdown timer
- Progress tracking
- Notification support

### 5. Weak Topic Tracker
- Automatic weak area detection
- Priority-based suggestions
- Revision schedules

### 6. Premium UI/UX
- Material Design 3
- Glassmorphism effects
- Smooth animations
- Dark mode support

## Technology Stack

- **Framework**: Flutter 3.10+
- **State Management**: Riverpod
- **Local Storage**: Hive + SharedPreferences
- **API**: Gemini AI (generativelanguage.googleapis.com)
- **HTTP Client**: Dio
- **UI**: Material Design 3
- **Fonts**: Google Fonts (Poppins, Inter)

## Setup Instructions

### Prerequisites
- Flutter 3.10 or higher
- Dart 3.0 or higher
- Android Studio / VS Code
- Gemini API Key

### Installation

1. **Clone the project**
```bash
cd focus-hsc-ai-flutter
```

2. **Install dependencies**
```bash
flutter pub get
flutter pub run build_runner build
```

3. **Configure API Key**
- Open `lib/constants/app_constants.dart`
- Replace `geminiApiKey` with your actual Gemini API key
- Or use environment variables (recommended for production)

4. **Run the app**
```bash
flutter run
```

5. **Build APK**
```bash
flutter build apk --release
```

6. **Build iOS**
```bash
flutter build ios --release
```

## Architecture

The app follows a clean architecture pattern with clear separation of concerns:

- **UI Layer**: Screens and Widgets
- **State Management**: Riverpod Providers
- **Business Logic**: Services
- **Data Layer**: Models and Local Storage

## API Integration

### Gemini AI Service
```dart
final aiService = GeminiAIService();
final response = await aiService.askQuestion(
  question: 'Your question',
  subject: 'English',
);
```

### Request Structure
- System prompt defines HSC exam context
- Temperature: 0.7 (balanced responses)
- Max tokens: 1024 (configurable)

## Database Schema

### Local Storage (Hive)
- **MCQQuestion**: Stores questions with user answers
- **StudyRoutineTask**: Daily tasks and progress
- **WeakTopic**: Tracks weak subjects
- **ChatHistory**: Conversation history

### SharedPreferences
- Theme settings
- Notification preferences
- User statistics
- Last study date

## Customization

### Adding New Subjects
1. Add subject to `AppStrings.subjects`
2. Define chapters in `AppConstants.subjectChapters`
3. Add subject-specific MCQs

### Modifying Theme
1. Edit colors in `lib/constants/app_colors.dart`
2. Update typography in `lib/utils/app_theme.dart`

### API Configuration
- Change `geminiApiKey` in constants
- Adjust request parameters for different response styles
- Modify system prompt for different contexts

## Performance Optimization

- Lazy loading of screens
- Efficient state management with Riverpod
- Image caching
- Offline MCQ support
- Minimal API calls design

## Security Best Practices

- API keys stored in local.properties (not in code)
- No sensitive data in logs
- Encrypted local storage (optional)
- Session management

## Known Limitations

- Single-user app (no authentication)
- Requires internet for AI responses
- MCQ database is in-memory (can be extended to API)
- Limited offline functionality

## Future Enhancements

1. Backend API for MCQ database
2. User authentication & cloud sync
3. Voice input/output
4. Offline AI responses
5. Advanced analytics
6. Group study features
7. Mock exam system
8. Performance benchmarking

## Troubleshooting

### Common Issues

**App crashes on startup**
- Clear build cache: `flutter clean`
- Rebuild: `flutter pub get && flutter run`

**API errors**
- Verify Gemini API key
- Check internet connection
- Review API quota limits

**Storage issues**
- Clear Hive boxes: `await Hive.deleteBoxFromDisk('box_name')`
- Reset preferences: `await prefs.clear()`

## Contributing

For improvements and bug fixes:
1. Create a feature branch
2. Test thoroughly
3. Submit pull request

## License

Proprietary - Focus HSC AI

## Support

For issues and questions, contact: support@focushsc.ai

## Version History

- **v1.0.0** (2026-05-08): Initial release
  - Core features implemented
  - AI chat functional
  - MCQ system complete
  - Routine tracking active
  - Weak topic detection

---

**Built with ❤️ for HSC 1st Year Arts Students**
