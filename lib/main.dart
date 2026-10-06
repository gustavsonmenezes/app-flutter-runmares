import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/app/app.dart';
import 'package:runmares/features/settings/data/settings_repository_provider.dart';
import 'package:runmares/features/settings/data/shared_preferences_settings_repository.dart';
import 'package:runmares/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(
          SharedPreferencesSettingsRepository(preferences),
        ),
      ],
      child: const RunMaresApp(),
    ),
  );
}
