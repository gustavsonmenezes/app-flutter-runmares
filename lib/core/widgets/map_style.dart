enum MapStyle {
  standard(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    maxNativeZoom: 19,
    attribution: 'OpenStreetMap contributors',
  ),
  dark(
    urlTemplate:
        'https://api.mapbox.com/styles/v1/mapbox/dark-v11/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
    maxNativeZoom: 19,
    attribution: 'Mapbox, OpenStreetMap contributors',
    isMapbox: true,
  ),
  mapboxOutdoors(
    urlTemplate:
        'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
    maxNativeZoom: 19,
    attribution: 'Mapbox, OpenStreetMap contributors',
    isMapbox: true,
  ),
  mapboxSatellite(
    urlTemplate:
        'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
    maxNativeZoom: 19,
    attribution: 'Mapbox, DigitalGlobe, OpenStreetMap contributors',
    isMapbox: true,
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
    this.isMapbox = false,
  });

  final String urlTemplate;
  final int maxNativeZoom;
  final String attribution;
  final bool isMapbox;

  static const String defaultMapboxToken =
      'pk.eyJ1IjoiZ3VzdGF2c29uYmFycm9zIiwiYSI6ImNtdjQ1cXV0MDA0cTgyeXByNWwzcTJ2ZjUifQ.TlrUfPmcVtg00D29q6TcMw';

  String resolvedUrl([String? token]) {
    if (!isMapbox) return urlTemplate;
    final activeToken = token ??
        const String.fromEnvironment('MAPBOX_ACCESS_TOKEN', defaultValue: defaultMapboxToken);
    return urlTemplate.replaceAll('{accessToken}', activeToken);
  }
}
