import 'package:flutter/material.dart';
import 'package:runmares/app/theme/app_colors.dart';

abstract final class AppTheme {
  static const double _buttonHeight = 52;
  static const double _borderRadius = 12;

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
    );
    const buttonSize = Size.fromHeight(_buttonHeight);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
        ),
      ),
    );
  }
}
