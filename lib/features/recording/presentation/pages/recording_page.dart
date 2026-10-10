import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/widgets/route_map.dart';
import 'package:runmares/features/recording/data/notification_permission_service_provider.dart';
import 'package:runmares/features/recording/domain/activity_save_status.dart';
import 'package:runmares/features/recording/domain/notification_permission_service.dart';
import 'package:runmares/features/recording/domain/pace_color_calculator.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
import 'package:runmares/features/recording/presentation/extensions/route_segments_extension.dart';
import 'package:runmares/features/recording/presentation/widgets/activity_type_selector.dart';
import 'package:runmares/features/recording/presentation/widgets/location_failure_notice.dart';
import 'package:runmares/features/recording/presentation/widgets/notification_permission_notice.dart';
import 'package:runmares/features/recording/presentation/widgets/recording_controls.dart';
import 'package:runmares/features/recording/presentation/widgets/recording_metrics.dart';
import 'package:runmares/features/settings/presentation/providers/settings_providers.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RecordingPage extends ConsumerStatefulWidget {
  const RecordingPage({super.key});

  @override
  ConsumerState<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends ConsumerState<RecordingPage> {
  NotificationPermission? _notificationPermission;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _requestNotificationPermission(),
    );
  }

  Future<void> _requestNotificationPermission() async {
    final service = ref.read(notificationPermissionServiceProvider);
    final permission = await service.request();
    if (!mounted) return;
    setState(() => _notificationPermission = permission);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingControllerProvider);
    final controller = ref.read(recordingControllerProvider.notifier);
    final unit = ref.watch(distanceUnitProvider);
    final mapStyle = ref.watch(mapStyleProvider);
    final isIdle = state.status == RecordingStatus.idle;
    final failure = state.locationFailure;
    final saveMessage = _saveMessage(state.saveStatus);
    final notificationPermission = _notificationPermission;
    final showNotificationNotice =
        notificationPermission != null &&
        notificationPermission != NotificationPermission.granted;

    // Gerenciar Wakelock com base no status do treino
    if (state.status == RecordingStatus.recording) {
      WakelockPlus.enable();
    } else if (state.status == RecordingStatus.idle ||
        state.status == RecordingStatus.finished) {
      WakelockPlus.disable();
    }

    final coloredSegments = PaceColorCalculator.calculateSegments(state.routeSegments);

    return Scaffold(
      appBar: AppBar(title: const Text('Gravar atividade')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActivityTypeSelector(
              selected: state.activityType,
              onChanged: isIdle ? controller.selectActivityType : null,
            ),
            const SizedBox(height: AppSpacing.itemGap),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.mapCornerRadius),
                child: RouteMap(
                  segments: state.routeSegments.toLatLngSegments(),
                  coloredSegments: coloredSegments,
                  showPaceLegend: true,
                  followLastPoint: true,
                  style: mapStyle,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            RecordingMetrics(
              distanceMeters: state.distanceMeters,
              elapsed: state.elapsed,
              unit: unit,
              showCurrentPace: true,
              currentPaceSecondsPerKilometer:
                  state.currentPaceSecondsPerKilometer,
              paceSecondsPerKilometer: state.averagePaceSecondsPerKilometer,
            ),
            const SizedBox(height: AppSpacing.itemGap),
            Text(
              _statusMessage(state.status),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (saveMessage != null) ...[
              const SizedBox(height: AppSpacing.itemGap),
              Text(saveMessage, textAlign: TextAlign.center),
            ],
            if (failure != null) ...[
              const SizedBox(height: AppSpacing.itemGap),
              LocationFailureNotice(
                reason: failure,
                onOpenSettings: ref
                    .read(locationServiceProvider)
                    .openAppSettings,
              ),
            ],
            if (showNotificationNotice) ...[
              const SizedBox(height: AppSpacing.itemGap),
              NotificationPermissionNotice(
                permission: notificationPermission,
                onRetry: _requestNotificationPermission,
                onOpenSettings: ref
                    .read(notificationPermissionServiceProvider)
                    .openSettings,
              ),
            ],
            const SizedBox(height: AppSpacing.itemGap),
            RecordingControls(
              status: state.status,
              onStart: controller.start,
              onPause: controller.pause,
              onResume: controller.resume,
              onFinish: () => _confirmFinish(context, controller),
              onNewActivity: controller.reset,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmFinish(
    BuildContext context,
    RecordingController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Finalizar atividade?'),
        content: const Text('Você não poderá retomar esta atividade depois.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );

    if (confirmed == true) await controller.finish();
  }

  String _statusMessage(RecordingStatus status) {
    return switch (status) {
      RecordingStatus.idle => 'Escolha o tipo e toque em Iniciar',
      RecordingStatus.recording => 'Gravando...',
      RecordingStatus.paused => 'Atividade pausada',
      RecordingStatus.finished => 'Atividade finalizada',
    };
  }

  String? _saveMessage(ActivitySaveStatus status) {
    return switch (status) {
      ActivitySaveStatus.none => null,
      ActivitySaveStatus.saving => 'Salvando atividade...',
      ActivitySaveStatus.saved => 'Atividade salva no aparelho',
      ActivitySaveStatus.failed => 'Não foi possível salvar a atividade',
    };
  }
}
