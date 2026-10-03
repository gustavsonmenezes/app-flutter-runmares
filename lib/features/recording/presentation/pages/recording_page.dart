import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/recording/data/location_service.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  final LocationService _locationService = LocationService();
  late Future<Position> _positionFuture;

  @override
  void initState() {
    super.initState();
    _positionFuture = _locationService.getCurrentPosition();
  }

  void _loadPosition() {
    setState(() {
      _positionFuture = _locationService.getCurrentPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gravar atividade')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: FutureBuilder<Position>(
            future: _positionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              final error = snapshot.error;
              if (error != null) {
                final isBlocked =
                    error is LocationException &&
                    error.reason ==
                        LocationFailureReason.permissionDeniedForever;

                return _LocationErrorView(
                  message: _errorMessage(error),
                  onRetry: _loadPosition,
                  onOpenSettings: isBlocked
                      ? _locationService.openAppSettings
                      : null,
                );
              }

              return _PositionView(position: snapshot.requireData);
            },
          ),
        ),
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is LocationException) {
      return switch (error.reason) {
        LocationFailureReason.serviceDisabled =>
          'O GPS está desligado. Ative a localização do aparelho.',
        LocationFailureReason.permissionDenied =>
          'Precisamos da permissão de localização para registrar o seu percurso.',
        LocationFailureReason.permissionDeniedForever =>
          'A permissão de localização está bloqueada. '
              'Libere nas configurações do aparelho.',
      };
    }
    return 'Não foi possível obter a sua localização.';
  }
}

class _PositionView extends StatelessWidget {
  const _PositionView({required this.position});

  final Position position;

  static const int _decimalPlaces = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Latitude: ${position.latitude.toStringAsFixed(_decimalPlaces)}'),
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          'Longitude: ${position.longitude.toStringAsFixed(_decimalPlaces)}',
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Text('Precisão: ${position.accuracy.toStringAsFixed(1)} m'),
      ],
    );
  }
}

class _LocationErrorView extends StatelessWidget {
  const _LocationErrorView({
    required this.message,
    required this.onRetry,
    this.onOpenSettings,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.itemGap),
        FilledButton(onPressed: onRetry, child: const Text('Tentar novamente')),
        if (onOpenSettings != null) ...[
          const SizedBox(height: AppSpacing.itemGap),
          TextButton(
            onPressed: onOpenSettings,
            child: const Text('Abrir configurações'),
          ),
        ],
      ],
    );
  }
}
