import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/core/model/entry_monthly_sums.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/meters/helper/chart_helper.dart';
import 'package:openmeter/features/meters/provider/chart_has_focus.dart';
import 'package:openmeter/features/meters/provider/current_details_meter.dart';
import 'package:openmeter/features/meters/provider/show_line_chart_provider.dart';
import 'package:openmeter/features/meters/widgets/details_meter/charts/no_entry.dart';
import 'package:openmeter/shared/constant/custom_icons.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:openmeter/shared/utils/convert_count.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

class UsageLineChart extends ConsumerStatefulWidget {
  const UsageLineChart({super.key});

  @override
  ConsumerState createState() => _UsageLineChartState();
}

class _UsageLineChartState extends ConsumerState<UsageLineChart> {
  final ChartHelper _helper = ChartHelper();
  final ConvertMeterUnit _convertMeterUnit = ConvertMeterUnit();

  bool _twelveMonths = true;
  bool _hasResetEntries = false;
  int _lastTime = 0;
  int _entryLength = 0;

  double _averageUsage = 0.0;

  List<dynamic> finalEntries = [];

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

    final List<EntryDto> reservedEntries =
        detailsMeter.entries.reversed.toList();

    if (_twelveMonths) {
      finalEntries = _helper.getLastMonths(reservedEntries);
    } else {
      finalEntries = _helper.convertEntryList(reservedEntries);
    }

    _averageUsage = _helper.calcAverageCountUsage(
      entries: finalEntries as List<EntryMonthlySums>,
      length: !_twelveMonths ? detailsMeter.entries.length : 12,
    );

    _hasResetEntries = detailsMeter.entries.any((element) => element.isReset);

    if (_hasResetEntries) {
      finalEntries =
          _helper.splitListByReset(finalEntries as List<EntryMonthlySums>);
    }

    final textTheme = Theme.of(context).textTheme.bodySmall!;

    return SizedBox(
      height: 300,
      width: 400,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headLine(textTheme, detailsMeter.meter),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5),
              child: _convertMeterUnit.getUnitWidget(
                count: '',
                unit: detailsMeter.meter.unit,
                textStyle: Theme.of(context).textTheme.bodySmall!,
              ),
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
            _filterActions(textTheme, detailsMeter.entries),
          ],
        ),
      ),
    );
  }

  Widget _headLine(TextStyle textTheme, MeterDto meter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
            top: 4,
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
            ref.read(showLineChartProvider.notifier).setState(false);
          },
          icon: Icon(
            Icons.bar_chart,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }

  Widget _filterActions(TextStyle textTheme, List entries) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
      child: Row(
        children: [
          FilterChip(
            label: const Text('12 Monate'),
            selected: _twelveMonths,
            showCheckmark: false,
            labelStyle: textTheme,
            onSelected: (value) {
              if (entries.length > 12) {
                setState(() {
                  _twelveMonths = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  List<LineChartBarData> _lineData() {
    final List<LineChartBarData> chartData = [];

    if (finalEntries[0] is List) {
      for (List<EntryMonthlySums> entry in finalEntries) {
        List<FlSpot> spots = entry.map((e) {
          double usage = 0.0;
          if (e.usage != -1) {
            usage = e.usage.toDouble();
          }

          DateTime date = DateTime(e.year, e.month);

          if (e.day != null) {
            date = DateTime(e.year, e.month, e.day!);
          }

          return FlSpot(
            date.millisecondsSinceEpoch.toDouble(),
            usage,
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
    } else {
      List<FlSpot> spots = finalEntries.map((e) {
        double usage = 0.0;
        if (e.usage != -1) {
          usage = e.usage.toDouble();
        }

        DateTime date = DateTime(e.year, e.month);

        if (e.day != null) {
          date = DateTime(e.year, e.month, e.day!);
        }

        return FlSpot(
          date.millisecondsSinceEpoch.toDouble(),
          usage,
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
              '$dateFormat \n ${ConvertCount.convertCount(e.y.toInt())} ${_convertMeterUnit.getUnitString(meter.unit)}',
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
