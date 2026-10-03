import 'package:flutter/material.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

class ActivityTypeSelector extends StatelessWidget {
  const ActivityTypeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ActivityType selected;
  final ValueChanged<ActivityType>? onChanged;

  @override
  Widget build(BuildContext context) {
    final callback = onChanged;

    return SegmentedButton<ActivityType>(
      showSelectedIcon: false,
      segments: [
        for (final type in ActivityType.values)
          ButtonSegment(
            value: type,
            label: Text(_labelOf(type)),
            icon: Icon(_iconOf(type)),
          ),
      ],
      selected: {selected},
      onSelectionChanged: callback == null
          ? null
          : (selection) => callback(selection.first),
    );
  }

  String _labelOf(ActivityType type) {
    return switch (type) {
      ActivityType.running => 'Corrida',
      ActivityType.walking => 'Caminhada',
      ActivityType.cycling => 'Bicicleta',
    };
  }

  IconData _iconOf(ActivityType type) {
    return switch (type) {
      ActivityType.running => Icons.directions_run,
      ActivityType.walking => Icons.directions_walk,
      ActivityType.cycling => Icons.directions_bike,
    };
  }
}
