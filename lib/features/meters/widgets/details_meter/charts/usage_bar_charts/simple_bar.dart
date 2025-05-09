import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/features/meters/provider/details_meter/chart/chart_has_focus.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';

import '../../../../../../shared/utils/convert_count.dart';
import '../../../../../../shared/utils/convert_meter_unit.dart';
import '../../../../helper/chart_helper.dart';
import '../../../../model/entry_monthly_sums.dart';
import '../../../../model/meter_dto.dart';

class SimpleUsageBarChart extends ConsumerWidget {
  final ChartHelper _helper = ChartHelper();
  final ConvertMeterUnit _convertMeterUnit = ConvertMeterUnit();

  final List<EntryMonthlySums> data;
  final MeterDto meter;
  final bool showTwelveMonths;

  SimpleUsageBarChart(
      {super.key,
      required this.data,
      required this.meter,
      required this.showTwelveMonths});

  AxisTitles _bottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 35,
        getTitlesWidget: (value, meta) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          String month = _helper.getTitleMonths(date.month);

          String text = showTwelveMonths ? month : '$month ${date.year % 100}';

          return SideTitleWidget(
            meta: meta,
            child: Transform.rotate(
              angle: -45,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: showTwelveMonths ? 12 : 10,
                ),
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

  List<BarChartGroupData> _barData(
      BuildContext context, List<EntryMonthlySums> data) {
    List<BarChartGroupData> barData = [];

    for (EntryMonthlySums entry in data) {
      DateTime date = DateTime(entry.year, entry.month);
      final key = date.millisecondsSinceEpoch;

      barData.add(
        BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
              toY: entry.usage.toDouble(),
              color: Theme.of(context).primaryColor,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }
    return barData;
  }

  BarTouchData _barTouchData(BuildContext context, WidgetRef ref) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => Theme.of(context).primaryColor,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(group.x.toInt());

          String formatDate =
              DateFormat(DateTimeFormats.dateMonthYearLong).format(date);

          String text =
              '$formatDate \n  ${ConvertCount.convertCount(rod.toY.toInt())} ${_convertMeterUnit.getUnitString(meter.unit)}';

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

  FlBorderData _borderData(BuildContext context) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaWidth = MediaQuery.sizeOf(context).width - 35;
    final bool chartHasFocus = ref.watch(chartHasFocusProvider);

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
          width: 440,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics:
                chartHasFocus ? const NeverScrollableScrollPhysics() : null,
            child: Container(
              padding: const EdgeInsets.only(top: 4),
              width: showTwelveMonths
                  ? mediaWidth
                  : max((data.length + 2) * 24, mediaWidth),
              child: BarChart(
                BarChartData(
                  barGroups: _barData(context, data),
                  titlesData: _titlesData(),
                  barTouchData: _barTouchData(context, ref),
                  borderData: _borderData(context),
                  gridData: _gridData(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
