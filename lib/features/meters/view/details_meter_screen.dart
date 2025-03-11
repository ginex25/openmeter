import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/meters/model/details_meter_model.dart';
import 'package:openmeter/features/meters/provider/details_meter_provider.dart';
import 'package:openmeter/features/meters/provider/entry_filter_provider.dart';
import 'package:openmeter/features/meters/provider/selected_entries_count.dart';
import 'package:openmeter/features/meters/view/add_meter_screen.dart';
import 'package:openmeter/features/meters/widgets/details_meter/add_entry.dart';
import 'package:openmeter/features/meters/widgets/details_meter/entry_card_list.dart';
import 'package:openmeter/features/tags/widget/horizontal_tags_list.dart';
import 'package:openmeter/ui/widgets/utils/selected_items_bar.dart';

class DetailsMeterScreen extends ConsumerWidget {
  final int meterId;

  const DetailsMeterScreen({super.key, required this.meterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsProvider = ref.watch(detailsMeterProvider(meterId));

    final int selectedEntriesCount = ref.watch(selectedEntriesCountProvider);

    return detailsProvider.when(
      data: (detailsMeter) {
        return Scaffold(
          appBar: selectedEntriesCount > 0
              ? _selectedAppBar(ref, selectedEntriesCount)
              : _unselectedAppBar(
                  context,
                  ref,
                  detailsMeter,
                ),
          body: PopScope(
            canPop: selectedEntriesCount == 0,
            onPopInvokedWithResult: (bool didPop, _) async {
              if (selectedEntriesCount > 0) {
                ref
                    .read(detailsMeterProvider(meterId).notifier)
                    .removeSelectedEntitiesState();
              } else {
                ref.invalidate(entryFilterProvider);
              }
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Zählernummer
                      _meterInformationWidget(context, detailsMeter.meter),
                      const Divider(),
                      HorizontalTagsList(
                        meterId: meterId,
                        tags: [],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EntryCardList(
                        entries: detailsMeter.entries,
                        meter: detailsMeter.meter,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // if (_meter.hasEntry) _detailsWidgets(chartProvider),
                    ],
                  ),
                ),
                if (selectedEntriesCount > 0)
                  SelectedItemsBar(
                    buttons: [
                      TextButton(
                        onPressed: () {
                          // TODO impl DatabaseSettingsProvider.setHasUpdate
                          // Provider.of<DatabaseSettingsProvider>(context, listen: false)
                          //     .setHasUpdate(true);

                          ref
                              .read(detailsMeterProvider(meterId).notifier)
                              .deleteSelectedEntries();
                        },
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5,
                          children: [
                            Icon(Icons.delete_outline, size: 28),
                            Text('Löschen'),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget _meterInformationWidget(BuildContext context, MeterDto meter) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SelectableText(
            meter.note,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            meter.room ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  AppBar _unselectedAppBar(
    BuildContext context,
    WidgetRef ref,
    DetailsMeterModel detailsMeter,
  ) {
    return AppBar(
      title: SelectableText(detailsMeter.meter.number),
      leading: BackButton(
        onPressed: () {
          ref.invalidate(entryFilterProvider);
          Navigator.of(context).pop();
        },
      ),
      actions: [
        AddEntry(
            meter: detailsMeter.meter,
            predictedCount: detailsMeter.predictCount),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddMeterScreen(detailsMeter: detailsMeter),
                ));
          },
          icon: const Icon(Icons.edit),
          tooltip: 'Zähler bearbeiten',
        ),
      ],
    );
  }

  AppBar _selectedAppBar(WidgetRef ref, int count) {
    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref
              .read(detailsMeterProvider(meterId).notifier)
              .removeSelectedEntitiesState();
        },
      ),
    );
  }
}
