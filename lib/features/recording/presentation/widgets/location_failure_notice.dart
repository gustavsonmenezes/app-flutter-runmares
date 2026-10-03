import 'package:flutter/material.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';

class LocationFailureNotice extends StatelessWidget {
  const LocationFailureNotice({
    required this.reason,
    required this.onOpenSettings,
    super.key,
  });

  final LocationFailureReason reason;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        if (reason == LocationFailureReason.permissionDeniedForever)
          TextButton(
            onPressed: onOpenSettings,
            child: const Text('Abrir configurações'),
          ),
      ],
    );
  }

  String get _message {
    return switch (reason) {
      LocationFailureReason.serviceDisabled =>
        'O GPS está desligado. Ative a localização do aparelho.',
      LocationFailureReason.permissionDenied =>
        'Precisamos da permissão de localização para registrar o seu percurso.',
      LocationFailureReason.permissionDeniedForever =>
        'A permissão de localização está bloqueada. '
            'Libere nas configurações do aparelho.',
      LocationFailureReason.unavailable =>
        'Não foi possível obter a sua localização.',
    };
  }
}
