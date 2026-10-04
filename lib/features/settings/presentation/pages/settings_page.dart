import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/presentation/providers/auth_state_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authStateProvider).value?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (email != null) ...[
              Text('Conectado como $email'),
              const SizedBox(height: AppSpacing.itemGap),
            ],
            const Text('Unidades, tipo de mapa e conta'),
            const SizedBox(height: AppSpacing.itemGap),
            FilledButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
