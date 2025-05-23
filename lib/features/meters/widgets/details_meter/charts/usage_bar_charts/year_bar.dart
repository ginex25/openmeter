import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/provider/details_meter/chart/chart_has_focus.dart';

import '../../../../../../shared/utils/convert_count.dart';
import '../../../../../../shared/utils/convert_meter_unit.dart';
import '../../../../helper/chart_helper.dart';
import '../../../../model/entry_monthly_sums.dart';
import '../../../../model/meter_dto.dart';

class YearBarChart extends ConsumerWidget {
  final ChartHelper _helper = ChartHelper();
  final ConvertMeterUnit _convertMeterUnit = ConvertMeterUnit();

  final List<EntryMonthlySums> data;
  final MeterDto meter;

  YearBarChart({super.key, required this.data, required this.meter});

  List<BarChartGroupData> _barGroups(Color color, Map<int, int> data) {
    final List<BarChartGroupData> barGroups = [];

    data.forEach((key, value) {
      barGroups.add(
        BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
              toY: value.toDouble(),
              color: color,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    });

    return barGroups;
  }

  AxisTitles _bottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 0.5,
        getTitlesWidget: (value, meta) {
          return SideTitleWidget(
            meta: meta,
            child: Text(
              value.toStringAsFixed(0),
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
      show: true,
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: _bottomTitles(),
      leftTitles: _leftTitles(),
    );
  }

  BarTouchData _barTouchData(Color color, WidgetRef ref) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => color,
        fitInsideHorizontally: true,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String text =
              ' ${ConvertCount.convertCount(rod.toY.toInt())} ${_convertMeterUnit.getUnitString(meter.unit)}';

          return BarTooltipItem(
            text,
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
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

  FlBorderData _borderData(Color color) {
    return FlBorderData(
      show: true,
      border: Border.all(
        color: color,
        width: 0.1,
      ),
    );
  }

  FlGridData _gridData() {
    return const FlGridData(show: false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<int, int> finalData = _helper.splitListInYears(data);

    final primaryColor = Theme.of(context).primaryColor;

    final mediaWidth = MediaQuery.sizeOf(context).width - 35;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 10),
          child: _convertMeterUnit.getUnitWidget(
            count: '',
            unit: meter.unit,
            textStyle: Theme.of(context).textTheme.bodySmall!,
          ),
        ),
        SizedBox(
          height: 220,
          width: mediaWidth,
          child: BarChart(
            BarChartData(
              barGroups: _barGroups(primaryColor, finalData),
              titlesData: _titlesData(),
              barTouchData: _barTouchData(primaryColor, ref),
              borderData: _borderData(Theme.of(context).hintColor),
              gridData: _gridData(),
            ),
          ),
        ),
      ],
    );
  }
}
