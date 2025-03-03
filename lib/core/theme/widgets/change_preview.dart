import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/utils/custom_colors.dart';

import '../../../utils/custom_icons.dart';

class ChangePreview extends ConsumerWidget {
  const ChangePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Card(
        child: Center(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.65,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(
                right: BorderSide(
                  width: 1,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
                bottom: BorderSide(
                  width: 1,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
                left: BorderSide(
                  width: 1,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
                top: BorderSide(
                  width: 1,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                _meterCard(theme),
                const Spacer(),
                _navBar(theme.compactNavigation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _meterInformation(BoxDecoration decoration, ThemeModel theme) {
    final double height = theme.fontSize.size.toDouble() - 2;

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(100),
      },
      children: [
        TableRow(
          children: [
            Column(
              children: [
                Container(
                  width: 60,
                  height: height - 2,
                  decoration: decoration,
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  width: 30,
                  height: height - 6,
                  decoration: decoration,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 60,
                  height: height - 2,
                  decoration: decoration,
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  width: 30,
                  height: height - 6,
                  decoration: decoration,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 80,
                  height: height - 2,
                  decoration: decoration,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  _meterCard(ThemeModel theme) {
    final color =
        theme.mode == ThemeMode.dark ? Colors.white30 : CustomColors.lightGrey;

    const radius = BorderRadius.all(Radius.circular(16));

    final decoration = BoxDecoration(
      color: color,
      borderRadius: radius,
    );

    final double height = theme.fontSize.size.toDouble() - 2;

    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    radius: 13,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 100,
                    height: height,
                    decoration: decoration,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _meterInformation(decoration, theme),
              const Spacer(),
              Center(
                child: Container(
                  width: 100,
                  height: height - 4,
                  decoration: decoration,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navBar(bool compactNavBar) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(9)),
      child: NavigationBar(
        selectedIndex: 0,
        height: 63,
        labelBehavior: compactNavBar
            ? NavigationDestinationLabelBehavior.alwaysHide
            : NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(CustomIcons.voltmeter),
            label: 'Zähler',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Objekte',
          ),
        ],
      ),
    );
  }
}
