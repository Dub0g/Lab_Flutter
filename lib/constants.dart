class Quality {
  final String emoji;
  final String label;
  const Quality(this.emoji, this.label);
}

const qualities = <Quality>[
  Quality('😫', 'Жахливо'),
  Quality('😕', 'Погано'),
  Quality('😐', 'Нормально'),
  Quality('🙂', 'Добре'),
  Quality('😍', 'Чудово'),
];
