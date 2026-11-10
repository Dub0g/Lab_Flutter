import 'package:flutter/material.dart';

import '../theme.dart';

/// Показує вибір часу у 24-годинному форматі.
/// Повертає нову дату (сьогодні + обраний час) або `null`, якщо вибір скасовано.
Future<DateTime?> pickTime(BuildContext context, DateTime initial) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
    initialEntryMode: TimePickerEntryMode.dial,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            onPrimary: AppColors.accentText,
            surface: AppColors.sheet,
            onSurface: AppColors.text,
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
      );
    },
  );
  if (picked == null) return null;
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
}
