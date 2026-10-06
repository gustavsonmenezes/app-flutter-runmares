enum DistanceUnit {
  kilometers(label: 'km', metersPerUnit: 1000),
  miles(label: 'mi', metersPerUnit: 1609.344);

  const DistanceUnit({required this.label, required this.metersPerUnit});

  final String label;
  final double metersPerUnit;
}
