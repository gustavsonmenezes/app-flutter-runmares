import 'package:flutter/material.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

extension ActivityTypePresentation on ActivityType {
  String get label {
    return switch (this) {
      ActivityType.running => 'Corrida',
      ActivityType.walking => 'Caminhada',
      ActivityType.cycling => 'Bicicleta',
    };
  }

  IconData get icon {
    return switch (this) {
      ActivityType.running => Icons.directions_run,
      ActivityType.walking => Icons.directions_walk,
      ActivityType.cycling => Icons.directions_bike,
    };
  }
}
