enum NotificationPermission { granted, denied, permanentlyDenied }

abstract interface class NotificationPermissionService {
  Future<NotificationPermission> request();

  Future<bool> openSettings();
}
