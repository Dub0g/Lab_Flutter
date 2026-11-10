String _pad(int n) => n.toString().padLeft(2, '0');

String formatTime(DateTime date) => '${_pad(date.hour)}:${_pad(date.minute)}';

/// Тривалість у хвилинах; якщо підйом "раніше" за відбій — вважаємо, що це наступна доба.
int calcDurationMinutes(DateTime bed, DateTime wake) {
  final bedMin = bed.hour * 60 + bed.minute;
  final wakeMin = wake.hour * 60 + wake.minute;
  var diff = wakeMin - bedMin;
  if (diff <= 0) diff += 24 * 60;
  return diff;
}

String formatDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '$m хв';
  if (m == 0) return '$h год';
  return '$h год $m хв';
}

/// Дата у форматі YYYY-MM-DD (за місцевим часом).
String todayKey() {
  final now = DateTime.now();
  return '${now.year}-${_pad(now.month)}-${_pad(now.day)}';
}

/// Сьогоднішня дата з указаним часом.
DateTime makeTime(int h, int m) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, h, m);
}
