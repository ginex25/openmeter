import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/meter_typ.dart';
import 'package:openmeter/features/meters/model/sort_model.dart';
import 'package:openmeter/features/meters/provider/sort_provider.dart';
import 'package:openmeter/features/tags/provider/show_tags_provider.dart';
import 'package:openmeter/features/tags/widget/horizontal_tags_list.dart';
import 'package:openmeter/utils/datetime_formats.dart';
import 'package:openmeter/utils/meter_typ.dart';

import '../../../utils/convert_meter_unit.dart';
import 'meter_circle_avatar.dart';

class MeterCard extends ConsumerWidget {
  final MeterDto meter;
  final DateTime? date;
  final String count;
  final Function()? onTap;

  const MeterCard({
    super.key,
    required this.meter,
    this.date,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomAvatar avatarData =
        meterTyps.firstWhere((element) => element.meterTyp == meter.typ).avatar;

    String dateText = 'none';

    if (date != null) {
      dateText = DateFormat(DateTimeFormats.dateGermanLong).format(date!);
    }

    final bool showTags = ref.watch(showTagsProvider);
    final SortModel sortModel = ref.watch(sortProviderProvider);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4),
        child: Card(
          elevation: Theme.of(context).cardTheme.elevation,
          color: meter.isSelected
              ? Theme.of(context).highlightColor
              : Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        MeterCircleAvatar(
                          color: avatarData.color,
                          icon: avatarData.icon,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          meter.typ,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    if (sortModel.sort == 'meter')
                      Text(
                        meter.room ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                _meterInformation(context),
                const SizedBox(
                  height: 10,
                ),
                if (showTags && meter.id != null)
                  HorizontalTagsList(
                    meterId: meter.id!,
                    tags: [],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'zuletzt geändert: $dateText',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _meterInformation(BuildContext context) {
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
                Text(
                  meter.number,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  "Zählernummer",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            Column(
              children: [
                if (count != 'none')
                  ConvertMeterUnit().getUnitWidget(
                    count: count,
                    unit: meter.unit,
                    textStyle: Theme.of(context).textTheme.bodyMedium!,
                  ),
                if (count == 'none')
                  Text(
                    "Kein Eintrag",
                    style: Theme.of(context).textTheme.bodyMedium!,
                    textAlign: TextAlign.center,
                  ),
                Text(
                  "Zählerstand",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  meter.note.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
