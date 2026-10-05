import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Relógio das estatísticas, separado para que os testes escolham a data.
final statisticsClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
