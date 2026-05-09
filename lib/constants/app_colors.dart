import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Deep Indigo & Royal Blue
  static const Color primaryLight = Color(0xFF4F46E5); // Indigo
  static const Color primaryDark = Color(0xFF312E81); // Dark Indigo
  static const Color primaryGradientStart = Color(0xFF6366F1); // Light Indigo
  static const Color primaryGradientEnd = Color(0xFF4F46E5); // Indigo

  // Surface Colors
  static const Color surfaceLight = Color(0xFFF9FAFB); // Off-white
  static const Color surfaceDark = Color(0xFF121212); // Dark surface
  static const Color cardLight = Color(0xFFFFFFFF); // White
  static const Color cardDark = Color(0xFF1E1E2E); // Card dark

  // Accent Colors
  static const Color successGreen = Color(0xFF10B981); // Correct answer
  static const Color errorRed = Color(0xFFF87171); // Wrong answer
  static const Color warningYellow = Color(0xFFFBBF24); // Warning
  static const Color infoBlue = Color(0xFF3B82F6); // Info

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF111827); // Dark gray
  static const Color textPrimaryDark = Color(0xFFF3F4F6); // Light gray
  static const Color textSecondaryLight = Color(0xFF6B7280); // Gray
  static const Color textSecondaryDark = Color(0xFFD1D5DB); // Light gray

  // Divider & Border
  static const Color dividerLight = Color(0xFFE5E7EB); // Light gray
  static const Color dividerDark = Color(0xFF374151); // Dark gray
  
  // Shadows
  static const Color shadowColor = Color(0x1A000000);

  // Gradient Background
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  // Glassmorphism overlay
  static const Color glassOverlay = Color(0x80FFFFFF); // White with opacity

  // Theme data helpers
  static LinearGradient correctAnswerGradient = LinearGradient(
    colors: [successGreen.withOpacity(0.2), successGreen.withOpacity(0.05)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient wrongAnswerGradient = LinearGradient(
    colors: [errorRed.withOpacity(0.2), errorRed.withOpacity(0.05)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
