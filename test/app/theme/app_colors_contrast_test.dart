import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/app/theme/app_theme.dart';

const double _textContrast = 4.5;
const double _largeTextContrast = 3;

double _contrast(Color first, Color second) {
  final lighter = math.max(first.computeLuminance(), second.computeLuminance());
  final darker = math.min(first.computeLuminance(), second.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('text contrast', () {
    test('the primary text is readable on the app surfaces', () {
      expect(
        _contrast(AppColors.textPrimary, AppColors.background),
        greaterThanOrEqualTo(_textContrast),
      );
      expect(
        _contrast(AppColors.textPrimary, AppColors.surfaceMuted),
        greaterThanOrEqualTo(_textContrast),
      );
    });

    test('the secondary text is readable on the app surfaces', () {
      expect(
        _contrast(AppColors.textSecondary, AppColors.background),
        greaterThanOrEqualTo(_textContrast),
      );
      expect(
        _contrast(AppColors.textSecondary, AppColors.surfaceMuted),
        greaterThanOrEqualTo(_textContrast),
      );
    });

    test('the dark orange is readable as small text', () {
      expect(
        _contrast(AppColors.primaryStrong, AppColors.background),
        greaterThanOrEqualTo(_textContrast),
      );
      expect(
        _contrast(AppColors.primaryStrong, AppColors.surfaceMuted),
        greaterThanOrEqualTo(_textContrast),
      );
    });

    test('white text on the bright orange only suits large bold text', () {
      expect(
        _contrast(Colors.white, AppColors.primary),
        greaterThanOrEqualTo(_largeTextContrast),
      );
    });
  });

  group('theme', () {
    test('uses the brand colors', () {
      final theme = AppTheme.light;

      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundLight);
    });

    test('keeps the numbers heavier than the body text', () {
      final textTheme = AppTheme.light.textTheme;

      expect(textTheme.displayMedium?.fontWeight, FontWeight.w800);
      expect(textTheme.bodyMedium?.fontWeight, isNot(FontWeight.w800));
    });
  });
}
