/// Один цикл сну ≈ 90 хвилин, на засинання в середньому йде ≈ 15 хвилин.
const cycleMin = 90;
const fallAsleepMin = 15;
const optimalCycles = 5;

class CycleResult {
  final int cycles;
  final int sleepMin;
  final DateTime time;
  const CycleResult(this.cycles, this.sleepMin, this.time);
}

DateTime _shift(DateTime date, int minutes) =>
    date.add(Duration(minutes: minutes));

/// Коли лягти, щоб прокинутись у час [wake] (наприкінці циклу).
List<CycleResult> bedtimesForWake(
  DateTime wake, {
  List<int> cycles = const [6, 5, 4],
}) {
  return [
    for (final n in cycles)
      CycleResult(n, n * cycleMin, _shift(wake, -(n * cycleMin + fallAsleepMin))),
  ];
}

/// Коли прокинутись, якщо лягти у час [bed].
List<CycleResult> wakeTimesForBed(
  DateTime bed, {
  List<int> cycles = const [4, 5, 6],
}) {
  return [
    for (final n in cycles)
      CycleResult(n, n * cycleMin, _shift(bed, fallAsleepMin + n * cycleMin)),
  ];
}

/// Правильна форма слова: 1 цикл, 2–4 цикли, 5+ циклів.
String cyclesWord(int n) {
  final last = n % 10;
  final lastTwo = n % 100;
  if (lastTwo >= 11 && lastTwo <= 14) return 'циклів';
  if (last == 1) return 'цикл';
  if (last >= 2 && last <= 4) return 'цикли';
  return 'циклів';
}
