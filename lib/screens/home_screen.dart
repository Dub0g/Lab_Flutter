import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/sleep_provider.dart';
import '../theme.dart';
import '../utils/time.dart';

const _userName = 'Богдан';

String _greeting() {
  final h = DateTime.now().hour;
  if (h >= 5 && h < 12) return 'Доброго ранку,';
  if (h >= 12 && h < 18) return 'Добрий день,';
  if (h >= 18 && h < 23) return 'Добрий вечір,';
  return 'Доброї ночі,';
}

class _Tile {
  final String title;
  final IconData icon;
  final Color color;
  final int tab;
  const _Tile(this.title, this.icon, this.color, this.tab);
}

const _tiles = <_Tile>[
  _Tile('Щоденник', Icons.menu_book, Color(0xFF818CF8), 1),
  _Tile('Розрахунок', Icons.calculate, AppColors.accent, 3),
  _Tile('Дихання', Icons.water_drop, Color(0xFF38BDF8), 4),
  _Tile('Звуки', Icons.music_note, AppColors.success, 4),
];

class HomeScreen extends StatelessWidget {
  /// Перехід на вкладку за індексом (0 — Головна, 1 — Щоденник, ...).
  final ValueChanged<int> onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<SleepProvider>().entries;

    // Статистика за останні 7 записів
    final recent = entries.take(7).toList();
    final hasData = recent.isNotEmpty;
    final avgQuality =
        hasData ? recent.fold<int>(0, (s, e) => s + e.quality) / recent.length : 0.0;
    final percent = (((avgQuality + 1) / 5) * 100).round();
    final avgMin = hasData
        ? (recent.fold<int>(0, (s, e) => s + e.durationMin) / recent.length).round()
        : 0;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: const TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      _userName,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _userName[0],
                    style: const TextStyle(
                      color: AppColors.accentText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _QualityCard(
              hasData: hasData,
              percent: percent,
              count: recent.length,
              avgMin: avgMin,
            ),
            const SizedBox(height: 26),
            const Text(
              'Швидкий доступ',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final t in _tiles)
                      SizedBox(
                        width: width,
                        child: _TileCard(tile: t, onTap: () => onNavigate(t.tab)),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityCard extends StatelessWidget {
  final bool hasData;
  final int percent;
  final int count;
  final int avgMin;

  const _QualityCard({
    required this.hasData,
    required this.percent,
    required this.count,
    required this.avgMin,
  });

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Якість сну',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 6),
          if (hasData) ...[
            Text.rich(
              TextSpan(
                text: '$percent',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
                children: const [
                  TextSpan(
                    text: '%',
                    style: TextStyle(fontSize: 20, color: AppColors.accent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Container(
                height: 6,
                color: AppColors.input,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: (percent / 100).clamp(0.0, 1.0),
                  child: Container(color: AppColors.accent),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Середня оцінка за останні записи ($count). '
              'Середня тривалість сну: ${formatDuration(avgMin)}.',
              style: bodyStyle,
            ),
          ] else ...[
            const Text(
              '—',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Додайте перший запис у щоденнику, і тут з’явиться ваша статистика.',
              style: bodyStyle,
            ),
          ],
        ],
      ),
    );
  }
}

class _TileCard extends StatelessWidget {
  final _Tile tile;
  final VoidCallback onTap;
  const _TileCard({required this.tile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: tile.color.withAlpha(0x26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(tile.icon, size: 20, color: tile.color),
              ),
              Text(
                tile.title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
