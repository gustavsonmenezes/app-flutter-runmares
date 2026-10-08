import 'package:flutter/material.dart';
import 'package:runmares/features/recording/domain/notification_permission_service.dart';

class NotificationPermissionNotice extends StatelessWidget {
  const NotificationPermissionNotice({
    required this.permission,
    required this.onRetry,
    required this.onOpenSettings,
    super.key,
  });

  final NotificationPermission permission;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final isBlocked = permission == NotificationPermission.permanentlyDenied;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'As notificações estão desativadas. A gravação continua funcionando, '
          'mas o aviso de gravação em andamento não aparece.',
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: isBlocked ? onOpenSettings : onRetry,
          child: Text(
            isBlocked ? 'Abrir configurações' : 'Permitir notificações',
          ),
        ),
      ],
    );
  }
}
