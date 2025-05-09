import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/helper/chart_helper.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/entry_monthly_sums.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/details_meter/chart/show_line_chart_provider.dart';
import 'package:openmeter/features/meters/provider/details_meter/current_details_meter.dart';
import 'package:openmeter/features/meters/provider/details_meter/entry/entry_filter_provider.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/no_entry.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/usage_bar_charts/simple_bar.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/usage_bar_charts/year_bar.dart';
import 'package:openmeter/shared/constant/custom_icons.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

import '../../../../model/entry_filter_model.dart';
import '../../../../provider/details_meter/entry/filtered_entries.dart';

class UsageBarChartCard extends ConsumerStatefulWidget {
  const UsageBarChartCard({super.key});

  @override
  ConsumerState createState() => _UsageBarChartCardState();
}

class _UsageBarChartCardState extends ConsumerState<UsageBarChartCard> {
  final ChartHelper _helper = ChartHelper();
  final ConvertMeterUnit _convertMeterUnit = ConvertMeterUnit();

  bool _showOnlyLastTwelveMonths = true;
  bool _compareYears = false;

  double _averageUsage = 0.0;

  @override
  Widget build(BuildContext context) {
    final detailsMeter = ref.watch(currentDetailsMeterProvider);

    final EntryFilterModel entryFilter = ref.watch(entryFilterProvider);

    List<EntryDto> entries = detailsMeter.entries;

    if (entryFilter.hasActiveFilter) {
      entries = ref.watch(filteredEntriesProvider);
    }

    if (entries.isEmpty) {
      return const NoEntry(
          text: 'Es sind keine oder zu wenige Einträge vorhanden');
    }

    final textTheme = Theme.of(context).textTheme.bodySmall!;

    List<EntryMonthlySums> sumMonths = [];

    final List<EntryDto> reservedEntries = entries.reversed.toList();

    final totalSumMonths = _helper.getSumInMonths(reservedEntries);

    if (_showOnlyLastTwelveMonths) {
      sumMonths = _helper.getLastMonths(reservedEntries);
    } else {
      sumMonths = totalSumMonths;
    }

    final totalMonths = _compareYears ? totalSumMonths : sumMonths;

    final totalEntries = _compareYears
        ? entries.length
        : (!_showOnlyLastTwelveMonths ? entries.length : 12);

    _averageUsage = _helper.calcAverageCountUsage(
        entries: totalMonths, length: totalEntries);

    return SizedBox(
      height: 200,
      width: 400,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headline(textTheme: textTheme, meter: detailsMeter.meter),
            const SizedBox(
              height: 15,
            ),
            if (!_compareYears)
              SimpleUsageBarChart(
                  data: sumMonths,
                  meter: detailsMeter.meter,
                  showTwelveMonths: _showOnlyLastTwelveMonths),
            if (_compareYears)
              YearBarChart(
                  data: _helper.getSumInMonths(reservedEntries),
                  meter: detailsMeter.meter),
            const Spacer(),
            _filterActions(
                textTheme: textTheme,
                entriesLength: entries.length,
                hasFilters: entryFilter.hasActiveFilter),
          ],
        ),
      ),
    );
  }

  Widget _headline({required TextStyle textTheme, required MeterDto meter}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: 8,
          ),
          child: Column(
            children: [
              Text(
                'Verbrauch',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    CustomIcons.empty_set,
                    size: textTheme.fontSize!,
                    color: textTheme.color!,
                  ),
                  Text(
                    '${_averageUsage.toStringAsFixed(2)} ${_convertMeterUnit.getUnitString(meter.unit)}',
                    style: textTheme,
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ref.read(showLineChartProvider.notifier).setState(true);
          },
          icon: Icon(Icons.stacked_line_chart,
              color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  Widget _filterActions(
      {required TextStyle textTheme,
      required int entriesLength,
      bool hasFilters = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
      child: Row(
        children: [
          FilterChip(
            label: const Text('12 Monate'),
            selected: _showOnlyLastTwelveMonths,
            showCheckmark: false,
            labelStyle: textTheme,
            onSelected: (value) {
              if (entriesLength > 12 && !_compareYears) {
                setState(() {
                  _showOnlyLastTwelveMonths = value;
                });
              }
            },
          ),
          const SizedBox(
            width: 8,
          ),
          FilterChip(
            label: const Text('Jahresvergleich'),
            selected: _compareYears,
            showCheckmark: false,
            labelStyle: textTheme,
            onSelected: (value) {
              if (entriesLength > 12 && !hasFilters) {
                setState(() {
                  _compareYears = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
