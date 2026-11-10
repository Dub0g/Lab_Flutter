import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/sleep_entry.dart';
import '../state/sleep_provider.dart';
import '../theme.dart';
import '../utils/time.dart';
import '../widgets/primary_button.dart';
import 'add_entry_sheet.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<SleepProvider>().entries;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Щоденник сну',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ваші записи про сон',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: entries.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Поки що немає записів. Додайте перший!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _EntryCard(entry: entries[i]),
                    ),
            ),
            PrimaryButton(
              label: 'Додати запис',
              icon: Icons.add,
              margin: const EdgeInsets.only(bottom: 12),
              onPressed: () => showAddEntrySheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final SleepEntry entry;
  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.bedtime} – ${entry.wake}',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatDuration(entry.durationMin)} · ${entry.date}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                if (entry.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    entry.notes,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                qualities[entry.quality].emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 6),
              Icon(
                entry.synced ? Icons.cloud_done : Icons.cloud_off,
                size: 16,
                color: entry.synced ? AppColors.success : AppColors.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
