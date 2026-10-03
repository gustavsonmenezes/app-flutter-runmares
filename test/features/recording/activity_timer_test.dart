import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/domain/activity_timer.dart';

void main() {
  late DateTime now;
  late ActivityTimer timer;

  void advance(int seconds) => now = now.add(Duration(seconds: seconds));

  setUp(() {
    now = DateTime(2026);
    timer = ActivityTimer(now: () => now);
  });

  test('is zero before starting', () {
    advance(30);

    expect(timer.elapsed, Duration.zero);
  });

  test('counts while running', () {
    timer.start();
    advance(30);

    expect(timer.elapsed, const Duration(seconds: 30));
  });

  test('stops counting while paused', () {
    timer.start();
    advance(30);
    timer.pause();
    advance(100);

    expect(timer.elapsed, const Duration(seconds: 30));
  });

  test('continues from where it stopped after resuming', () {
    timer.start();
    advance(30);
    timer.pause();
    advance(100);
    timer.start();
    advance(10);

    expect(timer.elapsed, const Duration(seconds: 40));
  });

  test('reset clears the elapsed time', () {
    timer.start();
    advance(30);

    timer.reset();

    expect(timer.elapsed, Duration.zero);
  });
}
