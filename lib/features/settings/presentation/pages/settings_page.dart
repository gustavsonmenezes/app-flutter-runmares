import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/presentation/providers/current_user_provider.dart';
import 'package:runmares/features/settings/presentation/providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(currentUserProvider)?.email;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (email != null) ...[
              Text('Conectado como $email', textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.screenPadding),
            ],
            Text('Unidade de distância', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.itemGap),
            SegmentedButton<DistanceUnit>(
              showSelectedIcon: false,
              segments: [
                for (final unit in DistanceUnit.values)
                  ButtonSegment(value: unit, label: Text(_unitName(unit))),
              ],
              selected: {settings.distanceUnit},
              onSelectionChanged: (selection) {
                controller.selectDistanceUnit(selection.first);
              },
            ),
            const SizedBox(height: AppSpacing.screenPadding),
            Text('Tipo de mapa', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.itemGap),
            SegmentedButton<MapStyle>(
              showSelectedIcon: false,
              segments: [
                for (final style in MapStyle.values)
                  ButtonSegment(value: style, label: Text(_styleName(style))),
              ],
              selected: {settings.mapStyle},
              onSelectionChanged: (selection) {
                controller.selectMapStyle(selection.first);
              },
            ),
            const SizedBox(height: AppSpacing.itemGap),
            Text(
              'O mapa precisa de internet para carregar o fundo.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.screenPadding),
            FilledButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }

  String _unitName(DistanceUnit unit) {
    return switch (unit) {
      DistanceUnit.kilometers => 'Quilômetros',
      DistanceUnit.miles => 'Milhas',
    };
  }

  String _styleName(MapStyle style) {
    return switch (style) {
      MapStyle.standard => 'Padrão',
      MapStyle.topographic => 'Topográfico',
    };
  }
}
