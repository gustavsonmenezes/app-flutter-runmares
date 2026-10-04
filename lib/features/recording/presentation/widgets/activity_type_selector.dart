import 'package:flutter/material.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';

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
          ButtonSegment(value: type, label: Text(type.label)),
      ],
      selected: {selected},
      onSelectionChanged: callback == null
          ? null
          : (selection) => callback(selection.first),
    );
  }
}
