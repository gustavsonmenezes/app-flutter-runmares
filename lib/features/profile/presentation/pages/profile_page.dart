import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dados do usuário e estatísticas semanais e mensais'),
            const SizedBox(height: AppSpacing.itemGap),
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
