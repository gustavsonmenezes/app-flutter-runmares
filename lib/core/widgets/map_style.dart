enum MapStyle {
  standard(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    maxNativeZoom: 19,
    attribution: 'OpenStreetMap contributors',
  ),
  topographic(
    urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
    maxNativeZoom: 17,
    attribution: 'OpenTopoMap (CC-BY-SA), OpenStreetMap contributors',
  );

  const MapStyle({
    required this.urlTemplate,
    required this.maxNativeZoom,
    required this.attribution,
  });

  final String urlTemplate;
  final int maxNativeZoom;
  final String attribution;
}
