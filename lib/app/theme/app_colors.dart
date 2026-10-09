import 'package:flutter/material.dart';

abstract final class AppColors {
  // Marca Strava Orange
  static const Color primary = Color(0xFFFC4C02);
  static const Color primaryStrong = Color(0xFFC73A00);
  static const Color primarySoft = Color(0x26FC4C02);

  // Dark Mode Surface & Backgrounds (Slate Dark)
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceMutedDark = Color(0xFF334155);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Light Mode Surface & Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMutedLight = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Legado / Atalhos Padrão
  static const Color textPrimary = Color(0xFF242428);
  static const Color textSecondary = Color(0xFF6D6D78);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2F2F5);
  static const Color divider = Color(0xFFE4E4EA);
  static const Color border = Color(0xFFCFCFD6);

  // Mapa, gráficos e acentos
  static const Color secondary = Color(0xFF3B82F6);
  static const Color routeStart = Color(0xFF10B981);
  static const Color accentSuccess = Color(0xFF10B981);
  static const Color accentWarning = Color(0xFFF59E0B);
}
