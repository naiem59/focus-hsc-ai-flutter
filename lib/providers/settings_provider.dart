import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

final preferencesServiceProvider = Provider((ref) {
  return PreferencesService();
});

// Dark mode provider
final darkModeProvider = StateProvider<bool>((ref) {
  return false;
});

// Notifications provider
final notificationsEnabledProvider = StateProvider<bool>((ref) {
  return true;
});

// Language provider
final languageProvider = StateProvider<String>((ref) {
  return 'en';
});

// Pomodoro timer provider
final pomodoroTimerProvider = StateProvider<PomodoroState>((ref) {
  return PomodoroState();
});

class PomodoroState {
  final bool isRunning;
  final int remainingSeconds;
  final bool isBreakTime;
  final int sessionsCompleted;

  PomodoroState({
    this.isRunning = false,
    this.remainingSeconds = 1500, // 25 minutes
    this.isBreakTime = false,
    this.sessionsCompleted = 0,
  });

  PomodoroState copyWith({
    bool? isRunning,
    int? remainingSeconds,
    bool? isBreakTime,
    int? sessionsCompleted,
  }) {
    return PomodoroState(
      isRunning: isRunning ?? this.isRunning,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isBreakTime: isBreakTime ?? this.isBreakTime,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
    );
  }
}
