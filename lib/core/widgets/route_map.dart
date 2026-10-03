import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:runmares/app/theme/app_colors.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({
    required this.segments,
    this.followLastPoint = false,
    super.key,
  });

  final List<List<LatLng>> segments;
  final bool followLastPoint;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  static const LatLng _defaultCenter = LatLng(-14.235, -51.9253);
  static const double _defaultZoom = 4;
  static const double _focusZoom = 17;
  static const double _routeWidth = 5;
  static const double _markerSize = 22;
  static const String _tileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String _userAgentPackage = 'br.com.runmares.runmares';

  final MapController _controller = MapController();

  @override
  void didUpdateWidget(RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.followLastPoint) return;

    final previous = _lastPointOf(oldWidget.segments);
    final current = _lastPointOf(widget.segments);
    if (current == null || current == previous) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final zoom = previous == null ? _focusZoom : _controller.camera.zoom;
      _controller.move(current, zoom);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastPoint = _lastPointOf(widget.segments);

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: lastPoint ?? _defaultCenter,
        initialZoom: lastPoint == null ? _defaultZoom : _focusZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: _tileUrl,
          userAgentPackageName: _userAgentPackage,
        ),
        PolylineLayer(
          polylines: [
            for (final segment in widget.segments)
              if (segment.length > 1)
                Polyline(
                  points: segment,
                  strokeWidth: _routeWidth,
                  color: AppColors.secondary,
                ),
          ],
        ),
        if (lastPoint != null)
          MarkerLayer(
            markers: [
              Marker(
                point: lastPoint,
                width: _markerSize,
                height: _markerSize,
                child: const _PositionDot(),
              ),
            ],
          ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }

  static LatLng? _lastPointOf(List<List<LatLng>> segments) {
    for (final segment in segments.reversed) {
      if (segment.isNotEmpty) return segment.last;
    }
    return null;
  }
}

class _PositionDot extends StatelessWidget {
  const _PositionDot();

  static const double _borderWidth = 3;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: _borderWidth),
      ),
    );
  }
}
