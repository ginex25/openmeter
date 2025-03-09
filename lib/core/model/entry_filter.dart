import '../../features/meters/model/entry_filter_model.dart';

class EntryFilterModel {
  Set<EntryFilters?> activeFilters = {};
  DateTime? filterByDateBegin;
  DateTime? filterByDateEnd;

  EntryFilterModel(
      this.activeFilters, this.filterByDateBegin, this.filterByDateEnd);
}
