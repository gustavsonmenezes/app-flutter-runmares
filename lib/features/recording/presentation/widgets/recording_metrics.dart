import 'package:flutter/material.dart';

class RecordingMetrics extends StatelessWidget {
  const RecordingMetrics({required this.distanceMeters, super.key});

  final double distanceMeters;

  static const double _metersPerKilometer = 1000;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final kilometers = (distanceMeters / _metersPerKilometer)
        .toStringAsFixed(2)
        .replaceAll('.', ',');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          kilometers,
          style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text('km', style: textTheme.titleMedium),
      ],
    );
  }
}
