import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/provider/archived_meters_list_provider.dart';
import 'package:openmeter/features/meters/provider/entry_filter_provider.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/meters/widgets/meter_card_list.dart';
import 'package:openmeter/shared/widgets/empty_archiv.dart';
import 'package:openmeter/shared/widgets/selected_items_bar.dart';

import 'details_meter_screen.dart';

class ArchivedMetersScreen extends ConsumerStatefulWidget {
  const ArchivedMetersScreen({super.key});

  @override
  ConsumerState createState() => _ArchivedMetersScreenState();
}

class _ArchivedMetersScreenState extends ConsumerState<ArchivedMetersScreen> {
  @override
  Widget build(BuildContext context) {
    final metersProvider = ref.watch(archivedMetersListProvider);

    final int selectedMetersCount = ref.watch(selectedMetersCountProvider);

    return Scaffold(
      appBar: selectedMetersCount > 0
          ? _selectedAppBar(selectedMetersCount)
          : AppBar(
              title: const Text('Archivierte Zähler'),
            ),
      body: metersProvider.when(
        data: (data) {
          if (data.isEmpty) {
            return EmptyArchiv(
                titel: 'Es wurden noch keine Zähler archiviert.');
          }

          return PopScope(
            canPop: selectedMetersCount == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (selectedMetersCount > 0) {
                ref
                    .read(archivedMetersListProvider.notifier)
                    .removeAllSelectedMetersState();
              }
            },
            child: Stack(
              children: [
                // MeterCardListOld(stream: stream, isHomescreen: false),
                MeterCardList(
                  meters: data,
                  onLongPress: (meter) {
                    ref
                        .read(archivedMetersListProvider.notifier)
                        .toggleMeterSelectedState(meter);
                  },
                  onDelete: (meter) {
                    ref
                        .read(archivedMetersListProvider.notifier)
                        .deleteMeter(meter);
                  },
                  onSidePanelAction: (meter) {
                    ref
                        .read(archivedMetersListProvider.notifier)
                        .removeFromArchive(meter);
                  },
                  startPanelLabel: 'Wiederherstellen',
                  startPanelIcon: Icons.unarchive,
                  onCardTap: (meter) {
                    if (selectedMetersCount > 0) {
                      ref
                          .read(archivedMetersListProvider.notifier)
                          .toggleMeterSelectedState(meter);
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) =>
                            DetailsMeterScreen(meterId: meter.id!),
                      ))
                          .then(
                        (value) {
                          ref.invalidate(entryFilterProvider);
                        },
                      );
                    }
                  },
                ),
                if (selectedMetersCount > 0) _selectedItems(),
              ],
            ),
          );
        },
        error: (error, stackTrace) => throw error,
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _selectedItems() {
    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).textTheme.bodyLarge!.color,
      ),
    );

    final buttons = [
      TextButton(
        onPressed: () {
          ref
              .read(archivedMetersListProvider.notifier)
              .unarchiveSelectedMeters();
        },
        style: buttonStyle,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.unarchive_outlined,
              size: 28,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Wiederherstellen'),
          ],
        ),
      ),
      TextButton(
        onPressed: () {
          ref
              .read(archivedMetersListProvider.notifier)
              .deleteAllSelectedMeters();
        },
        style: buttonStyle,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline,
              size: 28,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Löschen'),
          ],
        ),
      ),
    ];

    return SelectedItemsBar(buttons: buttons);
  }

  AppBar _selectedAppBar(int count) {
    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref
              .read(archivedMetersListProvider.notifier)
              .removeAllSelectedMetersState();
        },
      ),
    );
  }
}
