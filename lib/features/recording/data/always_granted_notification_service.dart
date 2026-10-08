import 'package:runmares/features/recording/domain/notification_permission_service.dart';

class AlwaysGrantedNotificationService
    implements NotificationPermissionService {
  const AlwaysGrantedNotificationService();

  @override
  Future<NotificationPermission> request() async {
    return NotificationPermission.granted;
  }

  @override
  Future<bool> openSettings() async => false;
}
