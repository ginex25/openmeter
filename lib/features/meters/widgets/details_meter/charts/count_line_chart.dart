import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/entry_monthly_sums.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/helper/chart_helper.dart';
import 'package:openmeter/features/meters/provider/chart_has_focus.dart';
import 'package:openmeter/features/meters/provider/current_details_meter.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/no_entry.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:openmeter/shared/utils/convert_count.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

class CountLineChart extends ConsumerStatefulWidget {
  const CountLineChart({super.key});

  @override
  ConsumerState createState() => _CountLineChartState();
}

class _CountLineChartState extends ConsumerState<CountLineChart> {
  final ChartHelper _helper = ChartHelper();
  final ConvertMeterUnit _convertMeterUnit = ConvertMeterUnit();

  List finalEntries = [];

  bool _twelveMonths = true;
  bool _hasResetEntries = false;
  int _lastTime = 0;
  int _entryLength = 0;

  _getTimeValues(List<EntryDto> entries) {
    _lastTime = entries.last.date.millisecondsSinceEpoch;
    _entryLength = entries.length;
  }

  @override
  Widget build(BuildContext context) {
    final detailsMeter = ref.watch(currentDetailsMeterProvider);

    if (detailsMeter.entries.isEmpty) {
      return const NoEntry(
          text: 'Es sind keine oder zu wenige Einträge vorhanden');
    }

    _getTimeValues(detailsMeter.entries);

    if (_twelveMonths) {
      finalEntries = _helper.getLastMonths(detailsMeter.entries);
    } else {
      finalEntries = _helper.convertEntryList(detailsMeter.entries);
    }

    _hasResetEntries = detailsMeter.entries.any((element) => element.isReset);

    if (_hasResetEntries) {
      finalEntries =
          _helper.splitListByReset(finalEntries as List<EntryMonthlySums>);
    }

    return SizedBox(
      height: 300,
      width: 400,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 8, top: 8),
              child: Text(
                'Zählerstand',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 37,
            ),
            SizedBox(
              height: 220,
              width: MediaQuery.sizeOf(context).width - 35,
              child: LineChart(
                LineChartData(
                  lineBarsData: _lineData(),
                  titlesData: _titlesData(),
                  borderData: _borderData(),
                  gridData: _gridData(),
                  lineTouchData: _touchData(detailsMeter.meter),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4),
              child: FilterChip(
                label: const Text('12 Monate'),
                selected: _twelveMonths,
                showCheckmark: false,
                labelStyle: Theme.of(context).textTheme.bodySmall!,
                onSelected: (value) {
                  if (detailsMeter.entries.length > 12) {
                    setState(() {
                      _twelveMonths = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> _lineData() {
    final List<LineChartBarData> chartData = [];

    if (finalEntries is List<List<EntryMonthlySums>>) {
      for (List<EntryMonthlySums> entry in finalEntries) {
        List<FlSpot> spots = entry.map((e) {
          final date = DateTime(e.year, e.month, e.day ?? 1);

          return FlSpot(
            date.millisecondsSinceEpoch.toDouble(),
            e.count?.toDouble() ?? 0,
          );
        }).toList();

        chartData.add(
          LineChartBarData(
            spots: spots,
            color: Theme.of(context).primaryColor,
            barWidth: 4,
            shadow: const Shadow(
              blurRadius: 0.2,
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
          ),
        );
      }
    } else if (finalEntries is List<EntryMonthlySums>) {
      List<FlSpot> spots = finalEntries.map((e) {
        final date = DateTime(e.year, e.month, e.day ?? 1);

        return FlSpot(
          date.millisecondsSinceEpoch.toDouble(),
          e.count?.toDouble() ?? 0,
        );
      }).toList();

      chartData.add(
        LineChartBarData(
          spots: spots,
          color: Theme.of(context).primaryColor,
          barWidth: 4,
          shadow: const Shadow(
            blurRadius: 0.2,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          ),
        ),
      );
    }

    return chartData;
  }

  AxisTitles _bottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: !_twelveMonths && _entryLength > 24
            ? _lastTime / _entryLength / 3.5
            : null,
        getTitlesWidget: (value, meta) {
          final DateTime date =
              DateTime.fromMillisecondsSinceEpoch(value.toInt());

          if (value == meta.min && !_twelveMonths ||
              value == meta.max ||
              value == meta.min) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8, right: 8.0),
            child: Text(
              DateFormat(DateTimeFormats.dateMonthYearShort)
                  .format(date)
                  .toString(),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  AxisTitles _leftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        getTitlesWidget: (value, meta) {
          if (value == meta.max || value == meta.min) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              meta.formattedValue,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: _bottomTitles(),
      leftTitles: _leftTitles(),
    );
  }

  FlBorderData _borderData() {
    return FlBorderData(
      show: true,
      border: Border.all(
        color: Theme.of(context).hintColor,
        width: 0.1,
      ),
    );
  }

  FlGridData _gridData() {
    return const FlGridData(show: false);
  }

  LineTouchData _touchData(MeterDto meter) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) => Theme.of(context).primaryColor,
        fitInsideHorizontally: true,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((e) {
            final DateTime date =
                DateTime.fromMillisecondsSinceEpoch(e.x.toInt());
            final String dateFormat =
                DateFormat(DateTimeFormats.dateGermanLong).format(date);

            return LineTooltipItem(
              '$dateFormat \n ${ConvertCount.convertCount(e.y.toInt())}  ${_convertMeterUnit.getUnitString(meter.unit)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList();
        },
      ),
      touchCallback: (event, touchResponse) {
        if (event is FlLongPressStart ||
            event is FlTapDownEvent ||
            event is FlPanStartEvent) {
          ref.read(chartHasFocusProvider.notifier).setState(true);
        }
        if (event is FlLongPressEnd ||
            event is FlTapUpEvent ||
            event is FlPanEndEvent) {
          ref.read(chartHasFocusProvider.notifier).setState(false);
        }
      },
    );
  }
}
