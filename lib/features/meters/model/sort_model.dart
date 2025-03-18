class SortModel {
  final String order;
  final String sort;

  SortModel(this.order, this.sort);

  SortModel copyWith({String? order, String? sort}) =>
      SortModel(order ?? this.order, sort ?? this.sort);
}
