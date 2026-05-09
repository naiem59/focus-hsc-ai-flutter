import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class PreferencesService {
  late SharedPreferences _prefs;
  final Logger _logger = Logger();

  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('PreferencesService initialized');
    } catch (e) {
      _logger.e('Error initializing PreferencesService: $e');
      rethrow;
    }
  }

  // Theme
  Future<void> setDarkMode(bool isDarkMode) async {
    await _prefs.setBool(AppConstants.prefDarkMode, isDarkMode);
  }

  bool getDarkMode() {
    return _prefs.getBool(AppConstants.prefDarkMode) ?? false;
  }

  // Notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.prefNotifications, enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(AppConstants.prefNotifications) ?? true;
  }

  // Language
  Future<void> setLanguage(String language) async {
    await _prefs.setString(AppConstants.prefLanguage, language);
  }

  String getLanguage() {
    return _prefs.getString(AppConstants.prefLanguage) ?? 'en';
  }

  // Study Statistics
  Future<void> setTotalMcqAnswered(int count) async {
    await _prefs.setInt(AppConstants.prefTotalMcqAnswered, count);
  }

  int getTotalMcqAnswered() {
    return _prefs.getInt(AppConstants.prefTotalMcqAnswered) ?? 0;
  }

  Future<void> setTotalMcqCorrect(int count) async {
    await _prefs.setInt(AppConstants.prefTotalMcqCorrect, count);
  }

  int getTotalMcqCorrect() {
    return _prefs.getInt(AppConstants.prefTotalMcqCorrect) ?? 0;
  }

  Future<void> setLastStudyDate(DateTime date) async {
    await _prefs.setString(AppConstants.prefLastStudyDate, date.toIso8601String());
  }

  DateTime? getLastStudyDate() {
    final dateStr = _prefs.getString(AppConstants.prefLastStudyDate);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  // Generic methods
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
