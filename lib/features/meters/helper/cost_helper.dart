import 'dart:developer';

import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/shared/constant/log.dart';

import '../../../core/helper/usage_helper.dart';

class CostHelper {
  final UsageHelper _usageHelper = UsageHelper();

  List<EntryDto> entries = [];
  int months = 0;
  bool isPredicted = false;
  double averageMonth = 0;
  double totalCosts = 0;
  int averageUsage = 0;

  double basicPrice = 0.0;
  double energyPrice = 0.0;
  double discount = 0.0;
  double totalPaid = 0.0;
  double difference = 0.0;

  List<EntryDto> _trimEntriesByDate(
      {required DateTime costUntil, required DateTime costFrom}) {
    entries.removeWhere((element) =>
        element.date.isAfter(costUntil) || element.date.isBefore(costFrom));

    return entries;
  }

  int _getSumOfMonthsBySelectedDate(
      {required DateTime costUntil, required DateTime costFrom}) {
    int monthDiff = costUntil.month - costFrom.month;
    int yearDiff = costUntil.year - costFrom.year;

    return yearDiff * 12 + monthDiff;
  }

  void _calcTotalPaid() {
    totalPaid = discount * months;
  }

  void _calcTotalCosts({DateTime? costUntil, DateTime? costFrom}) {
    try {
      final EntryDto lastEntry = entries.first;
      final EntryDto firstEntry = entries.last;

      int lastCount = lastEntry.count;
      int firstCount = firstEntry.count;

      double totalAverageUsage =
          _usageHelper.getTotalAverageUsage(lastEntry, firstEntry);

      if (costUntil != null && costUntil.isAfter(lastEntry.date)) {
        int diffDays = costUntil.difference(lastEntry.date).inDays;
        lastCount += (totalAverageUsage * diffDays).toInt();
        isPredicted = true;
      }

      if (costFrom != null && costFrom.isBefore(firstEntry.date)) {
        int diffDays = costFrom.difference(firstEntry.date).inDays.abs();
        firstCount -= (totalAverageUsage * diffDays).toInt();
        isPredicted = true;
      }

      double curBasicPrice = basicPrice / 365 * months;
      double curCountPrice = ((lastCount - firstCount) * energyPrice) / 100;

      averageUsage = lastCount - firstCount;

      totalCosts = curBasicPrice + curCountPrice;
      averageMonth = totalCosts / months;
    } catch (e) {
      averageUsage = 0;
      totalCosts = 0;
      averageMonth = 0;

      log('Error while calculate total coasts: ${e.toString()}',
          name: LogNames.costProvider);
    }
  }

  void initialCalc({DateTime? costUntil, DateTime? costFrom}) {
    if (costFrom != null && costUntil != null) {
      _trimEntriesByDate(costFrom: costFrom, costUntil: costUntil);
      months = _getSumOfMonthsBySelectedDate(
          costUntil: costUntil, costFrom: costFrom);
    } else {
      months = _usageHelper.getSumOfMonthsByEntry(entries);
    }

    _calcTotalCosts(costUntil: costUntil, costFrom: costFrom);
    _calcTotalPaid();

    difference = totalPaid - totalCosts;
  }
}
