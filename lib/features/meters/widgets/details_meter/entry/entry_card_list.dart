import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/theme/model/font_size_value.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/features/meters/helper/entry_helper.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/entry_filter_model.dart';
import 'package:openmeter/features/meters/provider/details_meter/current_details_meter.dart';
import 'package:openmeter/features/meters/provider/details_meter/details_meter_provider.dart';
import 'package:openmeter/features/meters/provider/details_meter/entry/entry_filter_provider.dart';
import 'package:openmeter/features/meters/provider/details_meter/entry/filtered_entries.dart';
import 'package:openmeter/features/meters/provider/details_meter/entry/selected_entries_count.dart';
import 'package:openmeter/features/meters/widgets/details_meter/entry/entry_details.dart';
import 'package:openmeter/features/meters/widgets/details_meter/entry/entry_filter_sheet.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:openmeter/shared/utils/convert_count.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

class EntryCardList extends ConsumerStatefulWidget {
  const EntryCardList({super.key});

  @override
  ConsumerState<EntryCardList> createState() => _EntryCardListState();
}

class _EntryCardListState extends ConsumerState<EntryCardList> {
  final EntryHelper _entryHelper = EntryHelper();

  @override
  Widget build(BuildContext context) {
    final EntryFilterModel entryFilter = ref.watch(entryFilterProvider);

    final bool hasFilter = entryFilter.hasActiveFilter;

    final themeModel = ref.watch(themeModeProviderProvider);

    bool isLargeText = themeModel.fontSize == FontSizeValue.large;

    final int selectedEntriesCount = ref.watch(selectedEntriesCountProvider);

    final detailsMeter = ref.watch(currentDetailsMeterProvider);

    List<EntryDto> entries = detailsMeter.entries;

    if (hasFilter) {
      entries = ref.watch(filteredEntriesProvider);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Zählerstand',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const EntryFilterButton(),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          if (hasFilter) _showHintHasFilter(context),
          if (hasFilter && entries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Es wurden keine Einträge mit den Filtern gefunden.',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          if (entries.isEmpty && !hasFilter)
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                'Es wurden noch keine Messungen eingetragen!\nDrücken Sie jetzt auf das  +  um einen neuen Eintrag zu erstellen.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          if (entries.isNotEmpty)
            SizedBox(
              height: isLargeText ? 150 : 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final EntryDto item = entries.elementAt(index);

                  bool hasNote = false;

                  if (item.note != null && item.note!.isNotEmpty) {
                    hasNote = true;
                  }

                  return GestureDetector(
                    onTap: () async {
                      if (selectedEntriesCount > 0) {
                        ref
                            .read(detailsMeterProvider(detailsMeter.meter.id!)
                                .notifier)
                            .toggleSelectedEntry(item);
                      } else {
                        showModalBottomSheet(
                          backgroundColor: Theme.of(context).cardTheme.color,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.65,
                              child: EntryDetails(
                                  entry: item, meter: detailsMeter.meter),
                            ),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      ref
                          .read(detailsMeterProvider(detailsMeter.meter.id!)
                              .notifier)
                          .toggleSelectedEntry(item);
                    },
                    child: SizedBox(
                      width: isLargeText ? 300 : 240,
                      child: Card(
                        color: item.isSelected == true
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).cardTheme.color,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _showDateAndNote(
                                item: item,
                                hasNote: hasNote,
                                context: context,
                              ),
                              const Divider(),
                              _showCountAndUsage(
                                item: item,
                                unit: detailsMeter.meter.unit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _showCountAndUsage({
    required EntryDto item,
    required String unit,
  }) {
    int usage = _entryHelper.getUsage(item);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            ConvertMeterUnit().getUnitWidget(
              count: ConvertCount.convertCount(item.count),
              unit: unit,
              textStyle: Theme.of(context).textTheme.bodyMedium!,
            ),
            Text(
              'Zählerstand',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        if (usage != -1)
          Column(
            children: [
              ConvertMeterUnit().getUnitWidget(
                count: usage.sign >= 0
                    ? '+${ConvertCount.convertCount(usage)}'
                    : ConvertCount.convertCount(usage),
                unit: unit,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: _entryHelper.getColors(item.count, usage),
                    ),
              ),
              Text(
                'innerhalb ${item.days} Tagen',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        if (usage == -1 && !item.isReset)
          Text(
            'Erstablesung',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (item.isReset)
          Text(
            'Zurückgesetzt',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
      ],
    );
  }

  Widget _showDateAndNote({
    required EntryDto item,
    required bool hasNote,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat(DateTimeFormats.dateGermanLong).format(item.date),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey,
              ),
        ),
        Row(
          children: [
            if (hasNote)
              const Icon(
                Icons.note,
                color: Colors.grey,
              ),
            if (item.transmittedToProvider)
              const Icon(
                Icons.upload_file_rounded,
                color: Colors.grey,
              ),
            if (item.imagePath != null)
              const Icon(
                Icons.image,
                color: Colors.grey,
              ),
          ],
        ),
      ],
    );
  }

  Widget _showHintHasFilter(BuildContext context) {
    final theme = Theme.of(context).textTheme.labelMedium;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 5,
            children: [
              Icon(
                Icons.info_outline,
                size: theme!.fontSize,
                color: theme.color,
              ),
              Text(
                'Einträge gefiltert',
                style: theme,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
