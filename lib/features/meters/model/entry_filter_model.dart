class EntryFilterModel {
  final DateTime? startDate;
  final DateTime? endDate;
  final Set<EntryFilters> filters;

  EntryFilterModel(this.startDate, this.endDate, this.filters);

  EntryFilterModel copyWith(
          {bool? note,
          bool? transmitted,
          bool? image,
          bool? reset,
          DateTime? startDate,
          DateTime? endDate,
          Set<EntryFilters>? filters}) =>
      EntryFilterModel(startDate ?? this.startDate, endDate ?? this.endDate,
          filters ?? this.filters);

  factory EntryFilterModel.initialFilter() => EntryFilterModel(null, null, {});

  bool get hasActiveFilter => filters.isNotEmpty;
}

enum EntryFilters {
  note,
  photo,
  transmitted,
  reset,
  dateBegin,
  dateEnd,
}
