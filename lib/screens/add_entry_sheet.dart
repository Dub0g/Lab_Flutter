import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/sleep_entry.dart';
import '../state/sleep_provider.dart';
import '../theme.dart';
import '../utils/time.dart';
import '../widgets/primary_button.dart';
import '../widgets/time_picker.dart';

/// Відкриває модальне вікно «Додати запис» знизу.
Future<void> showAddEntrySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0xB3050812),
    builder: (_) => const AddEntrySheet(),
  );
}

class AddEntrySheet extends StatefulWidget {
  const AddEntrySheet({super.key});

  @override
  State<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<AddEntrySheet> {
  DateTime _bedtime = makeTime(23, 30);
  DateTime _wake = makeTime(7, 15);
  int _quality = 3;
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickBed() async {
    final t = await pickTime(context, _bedtime);
    if (t != null) setState(() => _bedtime = t);
  }

  Future<void> _pickWake() async {
    final t = await pickTime(context, _wake);
    if (t != null) setState(() => _wake = t);
  }

  Future<void> _save() async {
    final provider = context.read<SleepProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final entry = SleepEntry(
      date: todayKey(),
      bedtime: formatTime(_bedtime),
      wake: formatTime(_wake),
      durationMin: calcDurationMinutes(_bedtime, _wake),
      quality: _quality,
      notes: _notes.text.trim(),
    );

    await provider.addEntry(entry);
    final error = provider.error;
    provider.clearError();

    navigator.pop();
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.card,
          content: Text(
            'Не вдалося синхронізувати ($error). Запис збережено локально.',
            style: const TextStyle(color: AppColors.danger),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<SleepProvider>().saving;
    final media = MediaQuery.of(context);
    final durationMin = calcDurationMinutes(_bedtime, _wake);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 28 + media.padding.bottom),
          decoration: const BoxDecoration(
            color: AppColors.sheet,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: Text(
                  'Додати запис 🌙',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _TimeBox(
                              label: 'Ліг спати',
                              value: _bedtime,
                              onTap: _pickBed,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _TimeBox(
                              label: 'Прокинувся',
                              value: _wake,
                              onTap: _pickWake,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Тривалість: ${formatDuration(durationMin)}',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const _Label('Якість сну'),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.input,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var i = 0; i < qualities.length; i++)
                              _QualityItem(
                                quality: qualities[i],
                                active: i == _quality,
                                onTap: () => setState(() => _quality = i),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          qualities[_quality].label,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const _Label('Нотатки (необов’язково)'),
                      TextField(
                        controller: _notes,
                        maxLength: 200,
                        minLines: 3,
                        maxLines: 6,
                        style: const TextStyle(color: AppColors.text, fontSize: 14),
                        cursorColor: AppColors.accent,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'Швидко заснув, але прокидався вночі...',
                          hintStyle: const TextStyle(color: AppColors.muted),
                          filled: true,
                          fillColor: AppColors.input,
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.accent),
                          ),
                        ),
                      ),
                      PrimaryButton(
                        label: 'Зберегти',
                        loading: saving,
                        margin: const EdgeInsets.only(top: 18),
                        onPressed: _save,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.muted, fontSize: 12),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final DateTime value;
  final VoidCallback onTap;
  const _TimeBox({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        Material(
          color: AppColors.input,
          borderRadius: BorderRadius.circular(AppRadius.md),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                formatTime(value),
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QualityItem extends StatelessWidget {
  final Quality quality;
  final bool active;
  final VoidCallback onTap;
  const _QualityItem({
    required this.quality,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: quality.label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 52,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.card : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: active ? Border.all(color: AppColors.accent) : null,
          ),
          child: Opacity(
            opacity: active ? 1 : 0.55,
            child: Text(
              quality.emoji,
              style: TextStyle(fontSize: active ? 28 : 22),
            ),
          ),
        ),
      ),
    );
  }
}
