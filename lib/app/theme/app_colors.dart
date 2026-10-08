import 'package:flutter/material.dart';

abstract final class AppColors {
  // Marca. O laranja vivo serve para botões, ícones e o trajeto; texto pequeno
  // laranja usa o tom escuro, que tem contraste suficiente sobre o branco.
  static const Color primary = Color(0xFFFC4C02);
  static const Color primaryStrong = Color(0xFFC73A00);
  static const Color primarySoft = Color(0xFFFFE7DC);

  // Texto
  static const Color textPrimary = Color(0xFF242428);
  static const Color textSecondary = Color(0xFF6D6D78);

  // Superfícies
  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2F2F5);
  static const Color divider = Color(0xFFE4E4EA);
  static const Color border = Color(0xFFCFCFD6);

  // Mapa e gráficos
  static const Color secondary = Color(0xFF2563EB);
  static const Color routeStart = Color(0xFF16A34A);
}
