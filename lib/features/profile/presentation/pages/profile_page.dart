import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/auth/presentation/providers/current_user_provider.dart';
import 'package:runmares/features/statistics/presentation/widgets/statistics_section.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(currentUserProvider)?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (email != null) ...[
              Text(email, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.itemGap),
            ],
            Text('Estatísticas', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.itemGap),
            const StatisticsSection(),
            const SizedBox(height: AppSpacing.screenPadding),
            FilledButton(
              onPressed: () => context.push(AppRoutes.settings),
              child: const Text('Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
