import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/history/presentation/providers/history_providers.dart';
import 'package:runmares/features/history/presentation/widgets/activity_list_tile.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activitySummariesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: activities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const _CenteredMessage('Não foi possível carregar o histórico.'),
        data: (items) {
          if (items.isEmpty) {
            return const _CenteredMessage(
              'Você ainda não registrou nenhuma atividade.',
            );
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final summary = items[index];
              return ActivityListTile(
                summary: summary,
                onTap: () => context.push(
                  AppRoutes.activityDetails(summary.id.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
