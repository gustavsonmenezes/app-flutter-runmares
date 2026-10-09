import 'package:flutter_tts/flutter_tts.dart';
import 'package:runmares/features/recording/domain/audio_announcer.dart';

class FlutterTtsAudioAnnouncer implements AudioAnnouncer {
  FlutterTtsAudioAnnouncer([FlutterTts? tts]) : _tts = tts ?? FlutterTts() {
    _init();
  }

  final FlutterTts _tts;
  bool _initialized = false;

  Future<void> _init() async {
    try {
      await _tts.setLanguage('pt-BR');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _initialized = true;
    } catch (_) {}
  }

  @override
  Future<void> announceKilometer({
    required int kilometerNumber,
    required Duration totalElapsed,
    required int? averagePaceSecondsPerKm,
  }) async {
    final minutes = totalElapsed.inMinutes;
    final seconds = totalElapsed.inSeconds.remainder(60);

    final paceMinutes = averagePaceSecondsPerKm != null
        ? averagePaceSecondsPerKm ~/ 60
        : 0;
    final paceSeconds = averagePaceSecondsPerKm != null
        ? averagePaceSecondsPerKm % 60
        : 0;

    final kmText =
        '$kilometerNumber ${kilometerNumber == 1 ? 'quilômetro' : 'quilômetros'}';
    final timeText =
        '$minutes ${minutes == 1 ? 'minuto' : 'minutos'}${seconds > 0 ? ' e $seconds ${seconds == 1 ? 'segundo' : 'segundos'}' : ''}';
    final paceText = averagePaceSecondsPerKm != null
        ? 'Pace médio: $paceMinutes ${paceMinutes == 1 ? 'minuto' : 'minutos'}${paceSeconds > 0 ? ' e $paceSeconds ${paceSeconds == 1 ? 'segundo' : 'segundos'}' : ''} por quilômetro.'
        : '';

    final announcement =
        'Quilômetro $kmText concluído. Tempo: $timeText. $paceText';
    await speak(announcement);
  }

  @override
  Future<void> speak(String text) async {
    if (!_initialized) await _init();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
