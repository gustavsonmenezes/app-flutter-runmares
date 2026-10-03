class ActivityTimer {
  ActivityTimer({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  Duration _accumulated = Duration.zero;
  DateTime? _runningSince;

  Duration get elapsed {
    final since = _runningSince;
    if (since == null) return _accumulated;
    return _accumulated + _now().difference(since);
  }

  void start() {
    _runningSince ??= _now();
  }

  void pause() {
    final since = _runningSince;
    if (since == null) return;

    _accumulated += _now().difference(since);
    _runningSince = null;
  }

  void reset() {
    _accumulated = Duration.zero;
    _runningSince = null;
  }
}
