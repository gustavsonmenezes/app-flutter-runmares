import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/features/recording/domain/colored_route_segment.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({
    required this.segments,
    this.coloredSegments,
    this.showPaceLegend = false,
    this.followLastPoint = false,
    this.fitRoute = false,
    this.style,
    super.key,
  });

  final List<List<LatLng>> segments;
  final List<ColoredRouteSegment>? coloredSegments;
  final bool showPaceLegend;
  final bool followLastPoint;
  final bool fitRoute;
  final MapStyle? style;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapStyle =
        widget.style ?? (isDark ? MapStyle.dark : MapStyle.standard);
    final hasColoredSegments =
        widget.coloredSegments != null && widget.coloredSegments!.isNotEmpty;

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: _buildOptions(points),
          children: [
            TileLayer(
              urlTemplate: mapStyle.urlTemplate,
              maxNativeZoom: mapStyle.maxNativeZoom,
              userAgentPackageName: _userAgentPackage,
            ),
            PolylineLayer(
              polylines: [
                if (hasColoredSegments)
                  for (final coloredSeg in widget.coloredSegments!)
                    if (coloredSeg.points.length > 1)
                      Polyline(
                        points: coloredSeg.points,
                        strokeWidth: _routeWidth,
                        color: coloredSeg.color,
                      )
                else
                  for (final segment in widget.segments)
                    if (segment.length > 1)
                      Polyline(
                        points: segment,
                        strokeWidth: _routeWidth,
                        color: AppColors.primary,
                      ),
              ],
            ),
            MarkerLayer(markers: _buildMarkers(points)),
            RichAttributionWidget(
              attributions: [TextSourceAttribution(mapStyle.attribution)],
            ),
          ],
        ),
        if (widget.showPaceLegend && hasColoredSegments)
          const _PaceLegendOverlay(),
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

class _PaceLegendOverlay extends StatelessWidget {
  const _PaceLegendOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _legendDot(AppColors.accentSuccess, 'Rápido'),
            const SizedBox(width: 8),
            _legendDot(AppColors.accentWarning, 'Médio'),
            const SizedBox(width: 8),
            _legendDot(const Color(0xFFEF4444), 'Lento'),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
