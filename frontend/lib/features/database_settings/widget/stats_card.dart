import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/features/database_settings/model/stats_model.dart';
import 'package:openmeter/features/database_settings/provider/stats_provider.dart';

const List<Color> itemColors = [
  Color(0xffC26DBC),
  Color(0xff603F8B),
  Color(0xff189AB4),
  Color(0xff025492),
  Color(0xffF67B50),
  Color(0xffF4B183),
];

const List<String> itemNames = [
  'Zähler',
  'Einträge',
  'Räume',
  'Verträge',
  'Tags',
  'Bilder'
];

class DatabaseStatsCard extends ConsumerStatefulWidget {
  const DatabaseStatsCard({super.key});

  @override
  ConsumerState createState() => _DatabaseStatsCardState();
}

class _DatabaseStatsCardState extends ConsumerState<DatabaseStatsCard> {
  bool _isLargeText = false;

  List<PieChartSectionData> _sections(List itemValues) {
    List<PieChartSectionData> result = [];

    if (itemValues.isEmpty) {
      return result;
    }

    for (int i = 0; i < 6; i++) {
      if (itemValues.elementAt(i).isNaN) {
        result.add(
          PieChartSectionData(
            color: Colors.grey.withValues(alpha: 0.3),
            value: 100,
            showTitle: false,
          ),
        );
        break;
      } else {
        result.add(
          PieChartSectionData(
            color: itemColors.elementAt(i),
            value: itemValues.elementAt(i),
            showTitle: false,
          ),
        );
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(databaseStatsProvider);

    return provider.when(
      data: (data) {
        final ThemeModel themeModel = ref.watch(themeModeProviderProvider);

        _isLargeText = themeModel.isLargeText;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speicherbelegung',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    _memoryUsage(data),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                _chart(data),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _indicator(String text, Color color) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 8,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _chart(DatabaseStatsModel stats) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sections: _sections(stats.itemValues),
                sectionsSpace: 0,
                centerSpaceRadius: 25,
              ),
            ),
          ),
        ),
        Expanded(
          flex: _isLargeText ? 3 : 2,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemColors.length,
            itemBuilder: (context, index) {
              int count = 0;

              if (stats.itemValues.isEmpty) {
                return Container();
              }

              if (!stats.itemValues.elementAt(index).isInfinite &&
                  !stats.itemValues.elementAt(index).isNaN) {
                count =
                    (stats.totalItemCounts * stats.itemValues.elementAt(index))
                        .toInt();
              }

              return Column(
                children: [
                  _indicator(
                    '${itemNames.elementAt(index)} ($count)',
                    itemColors.elementAt(index),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _memoryUsage(DatabaseStatsModel stats) {
    return Column(
      children: [
        Text(
          stats.fullSize,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            Row(
              spacing: 3,
              children: [
                const FaIcon(
                  FontAwesomeIcons.database,
                  size: 12,
                ),
                Text(
                  stats.databaseSize,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              spacing: 3,
              children: [
                const FaIcon(
                  FontAwesomeIcons.image,
                  size: 12,
                ),
                Text(
                  stats.imageSize,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
