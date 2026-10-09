import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/app/app.dart';
import 'package:runmares/features/recording/data/method_channel_notification_service.dart';
import 'package:runmares/features/recording/data/notification_permission_service_provider.dart';
import 'package:runmares/features/settings/data/settings_repository_provider.dart';
import 'package:runmares/features/settings/data/shared_preferences_settings_repository.dart';
import 'package:runmares/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tratamento de erros globais para evitar crashes silenciosos na inicialização
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Erro não tratado na plataforma: $error\n$stack');
    return true;
  };

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Aviso: Erro ao inicializar Firebase: $e');
  }

  SharedPreferences? preferences;
  try {
    preferences = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint('Aviso: Erro ao inicializar SharedPreferences: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        if (preferences != null)
          settingsRepositoryProvider.overrideWithValue(
            SharedPreferencesSettingsRepository(preferences),
          ),
        notificationPermissionServiceProvider.overrideWithValue(
          MethodChannelNotificationService(),
        ),
      ],
      child: const RunMaresApp(),
    ),
  );
}
