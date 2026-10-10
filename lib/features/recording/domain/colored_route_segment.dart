import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ColoredRouteSegment {
  const ColoredRouteSegment({
    required this.points,
    required this.color,
    this.paceSecondsPerKm,
  });

  final List<LatLng> points;
  final Color color;
  final int? paceSecondsPerKm;
}
