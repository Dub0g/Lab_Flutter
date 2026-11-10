class SleepEntry {
  final String id;
  final String date;
  final String bedtime;
  final String wake;
  final int durationMin;
  final int quality;
  final String notes;
  final int? remoteId;
  final bool synced;

  const SleepEntry({
    this.id = '',
    required this.date,
    required this.bedtime,
    required this.wake,
    required this.durationMin,
    required this.quality,
    this.notes = '',
    this.remoteId,
    this.synced = false,
  });

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: (json['id'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      bedtime: (json['bedtime'] ?? '').toString(),
      wake: (json['wake'] ?? '').toString(),
      durationMin: (json['durationMin'] as num?)?.toInt() ?? 0,
      quality: (json['quality'] as num?)?.toInt() ?? 0,
      notes: (json['notes'] ?? '').toString(),
      remoteId: (json['remoteId'] as num?)?.toInt(),
      synced: json['synced'] == true,
    );
  }

  SleepEntry copyWith({
    String? id,
    String? date,
    String? bedtime,
    String? wake,
    int? durationMin,
    int? quality,
    String? notes,
    int? remoteId,
    bool? synced,
  }) {
    return SleepEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      bedtime: bedtime ?? this.bedtime,
      wake: wake ?? this.wake,
      durationMin: durationMin ?? this.durationMin,
      quality: quality ?? this.quality,
      notes: notes ?? this.notes,
      remoteId: remoteId ?? this.remoteId,
      synced: synced ?? this.synced,
    );
  }

  /// Тіло запису, яке надсилається на сервер.
  Map<String, dynamic> toJson() => {
        'date': date,
        'bedtime': bedtime,
        'wake': wake,
        'durationMin': durationMin,
        'quality': quality,
        'notes': notes,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SleepEntry &&
        other.id == id &&
        other.date == date &&
        other.bedtime == bedtime &&
        other.wake == wake &&
        other.durationMin == durationMin &&
        other.quality == quality &&
        other.notes == notes &&
        other.remoteId == remoteId &&
        other.synced == synced;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      date,
      bedtime,
      wake,
      durationMin,
      quality,
      notes,
      remoteId,
      synced,
    );
  }
}
