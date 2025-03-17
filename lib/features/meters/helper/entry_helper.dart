import 'package:flutter/material.dart';
import 'package:openmeter/features/meters/helper/usage_helper.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/entry_filter_model.dart';
import 'package:openmeter/shared/utils/convert_count.dart';

class EntryHelper {
  final UsageHelper usageHelper = UsageHelper();

  int getUsage(EntryDto entry) {
    if (entry.usage == entry.count && entry.days == 0) {
      return -1;
    }

    return entry.usage;
  }

  String getDailyUsage(int usage, int days) {
    double div = usage / days;

    return ConvertCount.convertDouble(div);
  }

  getColors(int count, int usage) {
    if (usage <= 0) {
      return;
    }

    double percent = 100 / count * usage;

    if (percent < 2.3) {
      return Colors.green;
    } else if (percent < 5) {
      return Colors.orange;
    } else {
      return Colors.redAccent;
    }
  }

  String predictCount(EntryDto firstEntry, EntryDto lastEntry) {
    DateTime now = DateTime.now();

    int currentCount = lastEntry.count;
    double predictedUsage =
        usageHelper.getTotalAverageUsage(firstEntry, lastEntry);

    int diffDays = now.difference(lastEntry.date).inDays;
    double predictedCount = currentCount + (predictedUsage * diffDays);

    String predicted = predictedCount.ceil().toString();

    int stringLength = predicted.length;

    if (stringLength > 1) {
      return predicted.substring(0, stringLength ~/ 2);
    }

    return '';
  }

  int calcUsage(String currentCount, int countController) {
    int count = 0;

    if (currentCount == 'none') {
      return -1;
    } else {
      count = ConvertCount.convertString(currentCount);
    }

    return countController - count;
  }

  int calcDays(DateTime newDate, DateTime oldDate) {
    return newDate.difference(oldDate).inDays;
  }

  List<EntryDto> filterEntries(
      {required EntryFilterModel filter, required List<EntryDto> entries}) {
    List<EntryDto> result = entries;

    for (EntryFilters? filter in filter.filters) {
      if (filter == EntryFilters.note) {
        result.removeWhere(
            (element) => element.note == null || element.note!.isEmpty);
      }
      if (filter == EntryFilters.transmitted) {
        result.removeWhere((element) => !element.transmittedToProvider);
      }
      if (filter == EntryFilters.photo) {
        result.removeWhere((element) => element.imagePath == null);
      }
      if (filter == EntryFilters.reset) {
        result.removeWhere((element) => !element.isReset);
      }
    }

    if (filter.filters.contains(EntryFilters.dateBegin) ||
        filter.filters.contains(EntryFilters.dateEnd)) {
      result = _handleTimeRange(
        listToFilter: result,
        filter: filter,
      );
    }

    result.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return result;
  }

  List<EntryDto> _handleTimeRange(
      {required List<EntryDto> listToFilter,
      required EntryFilterModel filter}) {
    final Set<EntryFilters> activeFilters = filter.filters;
    final DateTime? filterBegin = filter.startDate;
    final DateTime? filterEnd = filter.endDate;

    if (filterBegin != null &&
        filterEnd != null &&
        activeFilters.contains(EntryFilters.dateBegin) &&
        activeFilters.contains(EntryFilters.dateEnd)) {
      return listToFilter
          .where((element) =>
              element.date.isBefore(filter.endDate!) &&
              element.date.isAfter(filter.startDate!))
          .toList();
    } else if (filterBegin != null &&
        activeFilters.contains(EntryFilters.dateBegin)) {
      return listToFilter
          .where((element) => element.date.isAfter(filterBegin))
          .toList();
    } else if (filterEnd != null &&
        activeFilters.contains(EntryFilters.dateEnd)) {
      return listToFilter
          .where((element) => element.date.isBefore(filterEnd))
          .toList();
    } else {
      return listToFilter;
    }
  }

  double calcUsageForContract(int usage, double energyPrice) {
    return (usage * energyPrice) / 100;
  }
}
