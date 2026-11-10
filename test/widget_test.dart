import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_helper/utils/sleep_cycles.dart';
import 'package:sleep_helper/utils/time.dart';

void main() {
  test('calcDurationMinutes переходить через північ', () {
    final bed = DateTime(2026, 1, 1, 23, 30);
    final wake = DateTime(2026, 1, 1, 7, 15);
    expect(calcDurationMinutes(bed, wake), 7 * 60 + 45);
  });

  test('formatDuration', () {
    expect(formatDuration(45), '45 хв');
    expect(formatDuration(120), '2 год');
    expect(formatDuration(465), '7 год 45 хв');
  });

  test('cyclesWord', () {
    expect(cyclesWord(1), 'цикл');
    expect(cyclesWord(4), 'цикли');
    expect(cyclesWord(5), 'циклів');
    expect(cyclesWord(11), 'циклів');
  });

  test('bedtimesForWake: 5 циклів до 07:00 → 23:15', () {
    final wake = DateTime(2026, 1, 1, 7, 0);
    final r = bedtimesForWake(wake).firstWhere((e) => e.cycles == 5);
    expect(formatTime(r.time), '23:15');
  });

  test('wakeTimesForBed: 5 циклів від 23:00 → 06:45', () {
    final bed = DateTime(2026, 1, 1, 23, 0);
    final r = wakeTimesForBed(bed).firstWhere((e) => e.cycles == 5);
    expect(formatTime(r.time), '06:45');
  });
}
