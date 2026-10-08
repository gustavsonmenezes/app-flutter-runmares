import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:runmares/features/recording/domain/notification_permission_service.dart';

class MethodChannelNotificationService
    implements NotificationPermissionService {
  MethodChannelNotificationService([MethodChannel? channel])
    : _channel = channel ?? const MethodChannel(channelName);

  static const String channelName = 'br.com.runmares/notifications';

  final MethodChannel _channel;

  @override
  Future<NotificationPermission> request() async {
    // A notificação do serviço de GPS só existe no Android. Em versões
    // anteriores ao Android 13 o sistema já concede a permissão.
    if (defaultTargetPlatform != TargetPlatform.android) {
      return NotificationPermission.granted;
    }

    try {
      final result = await _channel.invokeMethod<String>('requestPermission');
      return switch (result) {
        'granted' => NotificationPermission.granted,
        'permanentlyDenied' => NotificationPermission.permanentlyDenied,
        _ => NotificationPermission.denied,
      };
    } on Exception {
      return NotificationPermission.denied;
    }
  }

  @override
  Future<bool> openSettings() async {
    try {
      return await _channel.invokeMethod<bool>('openSettings') ?? false;
    } on Exception {
      return false;
    }
  }
}
