import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/sleep_cycles.dart';
import '../utils/time.dart';
import '../widgets/primary_button.dart';
import '../widgets/time_picker.dart';

const _badges = {4: 'Мінімум', 5: 'Оптимально', 6: 'Повноцінно'};

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  bool _isWake = true; // true = хочу прокинутись, false = хочу лягти
  DateTime _wakeTime = makeTime(7, 0);
  DateTime _bedTime = DateTime.now();
  List<CycleResult>? _results;

  DateTime get _time => _isWake ? _wakeTime : _bedTime;

  void _changeMode(bool isWake) {
    setState(() {
      _isWake = isWake;
      _results = null;
    });
  }

  Future<void> _pick() async {
    final t = await pickTime(context, _time);
    if (t == null) return;
    setState(() {
      if (_isWake) {
        _wakeTime = t;
      } else {
        _bedTime = t;
      }
      _results = null;
    });
  }

  void _calculate() {
    setState(() {
      _results = _isWake ? bedtimesForWake(_wakeTime) : wakeTimesForBed(_bedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Калькулятор сну',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Розрахунок $cycleMin-хвилинних циклів',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _Segment(isWake: _isWake, onChanged: _changeMode),
            const SizedBox(height: 28),
            InkWell(
              onTap: _pick,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      formatTime(_time),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 76,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isWake ? Icons.alarm : Icons.bed,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isWake ? 'Встановлено час підйому' : 'Встановлено час відбою',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Торкніться часу, щоб змінити',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              label: 'Розрахувати',
              margin: const EdgeInsets.only(top: 24),
              onPressed: _calculate,
            ),
            if (results != null) ...[
              const SizedBox(height: 24),
              Text(
                _isWake ? 'РЕКОМЕНДОВАНО ЛЯГТИ:' : 'РЕКОМЕНДОВАНО ПРОКИНУТИСЬ:',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              for (final r in results) _ResultCard(result: r),
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Враховано $fallAsleepMin хв на засинання. Прокидатися наприкінці циклу '
                  'легше, ніж посеред нього.',
                  style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final bool isWake;
  final ValueChanged<bool> onChanged;
  const _Segment({required this.isWake, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget item(String label, bool value) {
      final active = isWake == value;
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.input : null,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: active ? AppColors.text : AppColors.muted,
                fontSize: 13,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          item('Хочу прокинутись', true),
          item('Хочу лягти', false),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final CycleResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final optimal = result.cycles == optimalCycles;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: optimal ? AppColors.accent : AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatTime(result.time),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${result.cycles} ${cyclesWord(result.cycles)} '
                  '(${formatDuration(result.sleepMin)} сну)',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: optimal ? const Color(0x2EFBBF24) : AppColors.input,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _badges[result.cycles] ?? '',
              style: TextStyle(
                color: optimal ? AppColors.accent : AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
