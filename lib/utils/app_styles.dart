import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppGradients {
  static const LinearGradient primaryGradient = AppColors.primaryGradient;

  static LinearGradient getGradientByName(String name) {
    switch (name.toLowerCase()) {
      case 'success':
        return LinearGradient(
          colors: [
            AppColors.successGreen.withOpacity(0.2),
            AppColors.successGreen.withOpacity(0.05),
          ],
        );
      case 'error':
        return LinearGradient(
          colors: [
            AppColors.errorRed.withOpacity(0.2),
            AppColors.errorRed.withOpacity(0.05),
          ],
        );
      case 'warning':
        return LinearGradient(
          colors: [
            AppColors.warningYellow.withOpacity(0.2),
            AppColors.warningYellow.withOpacity(0.05),
          ],
        );
      default:
        return primaryGradient;
    }
  }
}

class AppShadows {
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppTypography {
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
