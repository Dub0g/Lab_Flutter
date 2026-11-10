import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/sleep_entry.dart';

class _ServerException implements Exception {
  final String message;
  _ServerException(this.message);
}

/// Стан щоденника сну (замінює Redux-слайс `sleep`).
class SleepProvider extends ChangeNotifier {
  final List<SleepEntry> _entries = [];
  bool _saving = false;
  String? _error;

  UnmodifiableListView<SleepEntry> get entries => UnmodifiableListView(_entries);
  bool get saving => _saving;
  String? get error => _error;

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  /// Після збереження надсилаємо запис на тестовий REST-сервер.
  /// Якщо мережі немає — запис усе одно зберігається локально (synced: false).
  Future<void> addEntry(SleepEntry draft) async {
    _saving = true;
    _error = null;
    notifyListeners();

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final res = await http
          .post(
            Uri.parse('https://jsonplaceholder.typicode.com/posts'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({
              'title': 'sleep-entry-${draft.date}',
              'body': jsonEncode(draft.toJson()),
              'userId': 1,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw _ServerException('Помилка сервера: ${res.statusCode}');
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      _entries.insert(
        0,
        draft.copyWith(id: id, remoteId: data['id'] as int?, synced: true),
      );
    } catch (e) {
      _error = e is _ServerException ? e.message : 'Немає з’єднання';
      _entries.insert(0, draft.copyWith(id: id, synced: false));
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
