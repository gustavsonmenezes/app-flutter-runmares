import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/core/widgets/map_style.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({
    required this.segments,
    this.followLastPoint = false,
    this.fitRoute = false,
    this.style = MapStyle.standard,
    super.key,
  });

  final List<List<LatLng>> segments;
  final bool followLastPoint;
  final bool fitRoute;
  final MapStyle style;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  static const LatLng _defaultCenter = LatLng(-14.235, -51.9253);
  static const double _defaultZoom = 4;
  static const double _focusZoom = 17;
  static const double _fitPadding = 32;
  static const double _routeWidth = 5;
  static const double _markerSize = 22;
  static const String _userAgentPackage = 'br.com.runmares.runmares';

  final MapController _controller = MapController();

  @override
  void didUpdateWidget(RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.followLastPoint || widget.fitRoute) return;

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
    final points = [for (final segment in widget.segments) ...segment];

    return FlutterMap(
      mapController: _controller,
      options: _buildOptions(points),
      children: [
        TileLayer(
          urlTemplate: widget.style.urlTemplate,
          maxNativeZoom: widget.style.maxNativeZoom,
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
        MarkerLayer(markers: _buildMarkers(points)),
        RichAttributionWidget(
          attributions: [TextSourceAttribution(widget.style.attribution)],
        ),
      ],
    );
  }

  MapOptions _buildOptions(List<LatLng> points) {
    if (widget.fitRoute && points.isNotEmpty) {
      return MapOptions(
        initialCameraFit: CameraFit.coordinates(
          coordinates: points,
          padding: const EdgeInsets.all(_fitPadding),
          maxZoom: _focusZoom,
        ),
      );
    }

    final center = points.isEmpty ? null : points.last;
    return MapOptions(
      initialCenter: center ?? _defaultCenter,
      initialZoom: center == null ? _defaultZoom : _focusZoom,
    );
  }

  List<Marker> _buildMarkers(List<LatLng> points) {
    if (points.isEmpty) return const [];
    if (!widget.fitRoute) return [_marker(points.last, AppColors.primary)];

    return [
      _marker(points.first, AppColors.routeStart),
      _marker(points.last, AppColors.primary),
    ];
  }

  Marker _marker(LatLng point, Color color) {
    return Marker(
      point: point,
      width: _markerSize,
      height: _markerSize,
      child: _PositionDot(color: color),
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
  const _PositionDot({required this.color});

  final Color color;

  static const double _borderWidth = 3;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: _borderWidth),
      ),
    );
  }
}
