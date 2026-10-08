import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/recording/data/always_granted_notification_service.dart';
import 'package:runmares/features/recording/domain/notification_permission_service.dart';

/// O padrão sempre concede. O `main` o substitui pela versão que pede a
/// permissão de verdade, e os testes usam o padrão ou uma versão falsa.
final notificationPermissionServiceProvider =
    Provider<NotificationPermissionService>(
      (ref) => const AlwaysGrantedNotificationService(),
    );
