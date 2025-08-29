class RemindLater {
  final RemindLaterType type;
  final int time;

  RemindLater(this.type, this.time);

  RemindLater copyWith({
    RemindLaterType? type,
    int? time,
  }) {
    return RemindLater(
      type ?? this.type,
      time ?? this.time,
    );
  }

  Map<String, dynamic> get toJson => {'type': type.name, 'time': time};

  factory RemindLater.fromJson(Map<String, dynamic> json) => RemindLater(
      RemindLaterType.values.firstWhere(
        (element) => json['type'] == element.name,
      ),
      json['time']);

  factory RemindLater.initialize() => RemindLater(RemindLaterType.hour, 1);
}

enum RemindLaterType {
  day(7),
  hour(23),
  minute(59);

  final int max;

  const RemindLaterType(this.max);
}
