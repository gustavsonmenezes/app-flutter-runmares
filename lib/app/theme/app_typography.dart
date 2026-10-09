import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runmares/app/theme/app_colors.dart';

abstract final class AppTypography {
  /// Números e títulos pesados, rótulos leves em cinza com fontes do Google Fonts
  /// e números tabulares para evitar trepidação no cronômetro.
  static TextTheme textTheme({Brightness brightness = Brightness.light}) {
    final textColor = brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondaryTextColor = brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final isTestEnvironment = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('Test');
    final baseTextTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
    ).textTheme;

    final base = isTestEnvironment
        ? baseTextTheme.apply(bodyColor: textColor, displayColor: textColor)
        : GoogleFonts.interTextTheme(
            baseTextTheme,
          ).apply(bodyColor: textColor, displayColor: textColor);

    const tabularFigures = FontFeature.tabularFigures();

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        fontFeatures: const [tabularFigures],
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        fontFeatures: const [tabularFigures],
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        fontFeatures: const [tabularFigures],
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        fontFeatures: const [tabularFigures],
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.25,
        fontFeatures: const [tabularFigures],
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        fontFeatures: const [tabularFigures],
      ),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      bodySmall: base.bodySmall?.copyWith(color: secondaryTextColor),
    );
  }
}
