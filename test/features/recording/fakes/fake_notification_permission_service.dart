import 'package:runmares/features/recording/domain/notification_permission_service.dart';

class FakeNotificationPermissionService
    implements NotificationPermissionService {
  FakeNotificationPermissionService(this.result);

  NotificationPermission result;
  int requestCount = 0;
  bool settingsOpened = false;

  @override
  Future<NotificationPermission> request() async {
    requestCount++;
    return result;
  }

  @override
  Future<bool> openSettings() async {
    settingsOpened = true;
    return true;
  }
}
