import 'package:openmeter/features/meters/model/entry_filter_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entry_filter_provider.g.dart';

@riverpod
class EntryFilter extends _$EntryFilter {
  @override
  EntryFilterModel build() {
    return EntryFilterModel.initialFilter();
  }

  void resetFilter() {
    state = EntryFilterModel.initialFilter();
  }

  void updateFilters(Set<EntryFilters> filter) {
    state = state.copyWith(filters: filter);
  }

  void addFilter(EntryFilters newFilter) {
    final filter = state.filters;

    filter.add(newFilter);

    state = state.copyWith(filters: filter);
  }

  void updateStartDate(DateTime? date) {
    state = state.copyWith(startDate: date);
  }

  void updateEndDate(DateTime? date) {
    state = state.copyWith(endDate: date);
  }

  void removeSpecificFilter(EntryFilters filter) {
    final Set<EntryFilters> newFilters = state.filters;

    newFilters.removeWhere(
      (element) => element == filter,
    );

    state = state.copyWith(filters: newFilters);
  }
}
