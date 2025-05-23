import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/archvied_meters_count_provider.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/meters/provider/search_meter_provider.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/meters/view/add_meter_screen.dart';
import 'package:openmeter/features/meters/view/details_meter_screen.dart';
import 'package:openmeter/features/meters/widgets/meter_card_list.dart';
import 'package:openmeter/features/meters/widgets/sort_icon_button.dart';
import 'package:openmeter/shared/widgets/empty_data.dart';
import 'package:openmeter/shared/widgets/search_bar.dart';
import 'package:openmeter/shared/widgets/selected_count_app_bar.dart';
import 'package:openmeter/shared/widgets/selected_items_bar.dart';

class MeterListScreen extends ConsumerStatefulWidget {
  const MeterListScreen({super.key});

  @override
  ConsumerState createState() => _MeterListScreenState();
}

class _MeterListScreenState extends ConsumerState<MeterListScreen> {
  Widget _meterListWidget(List<MeterDto> data, int selectedMetersCount, bool emptySearch) {
    if (data.isEmpty && !emptySearch) {
      return const EmptyData();
    }

    if (data.isEmpty && emptySearch) {
      return Center(
        child: Text(
          'Es wurden keine Zähler gefunden.',
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    final archivedMetersLengthProvider = ref.watch(archivedMetersCountProvider);

    return PopScope(
      onPopInvokedWithResult: (bool didPop, _) async {
        if (selectedMetersCount > 0) {
          ref.read(meterListProvider.notifier).removeAllSelectedMetersState();
        }
      },
      canPop: selectedMetersCount == 0,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                MeterCardList(
                  meters: data,
                  onLongPress: (MeterDto selectedMeter) {
                    ref.read(meterListProvider.notifier).toggleMeterSelectedState(selectedMeter);
                  },
                  onDelete: (MeterDto meter) {
                    ref.read(meterListProvider.notifier).deleteMeter(meter);
                  },
                  onSidePanelAction: (meter) {
                    ref.read(meterListProvider.notifier).archiveMeter(meter);
                  },
                  onCardTap: (meter) {
                    if (selectedMetersCount > 0) {
                      ref.read(meterListProvider.notifier).toggleMeterSelectedState(meter);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsMeterScreen(meterId: meter.id!),
                      ));
                    }
                  },
                ),
                if (selectedMetersCount == 0)
                  archivedMetersLengthProvider.when(
                    data: (data) => TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('archive');
                      },
                      child: Text(
                        'Archivierte Zähler ($data)',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    error: (error, _) => throw error,
                    loading: () => Container(),
                  ),
              ],
            ),
          ),
          if (selectedMetersCount > 0) _selectedItems(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int selectedMetersCount = ref.watch(selectedMetersCountProvider);

    final searchMeters = ref.watch(searchMeterProvider);

    final meterProvider = ref.watch(meterListProvider);

    return Scaffold(
      appBar: selectedMetersCount > 0
          ? SelectedCountAppBar(
              count: selectedMetersCount,
              onCancelButton: () {
                ref.read(meterListProvider.notifier).removeAllSelectedMetersState();
              },
            )
          : SearchAppBar(
              title: 'OpenMeter',
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMeterScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  tooltip: 'Zähler erstellen',
                ),
                SortIconButton(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('settings');
                    // .then((value) => provider.setStateHasUpdate(true));
                  },
                  icon: const Icon(Icons.settings),
                  tooltip: 'Einstellungen',
                ),
              ],
              onSearch: (searchText) {
                if (searchText.isEmpty || searchText.length <= 2) {
                  ref.read(searchMeterProvider.notifier).resetSearchState();
                }

                if (searchText.length > 2) {
                  ref.read(searchMeterProvider.notifier).searchMeter(searchText);
                }
              },
            ),
      body: searchMeters != null
          ? _meterListWidget(searchMeters, selectedMetersCount, true)
          : meterProvider.when(
              data: (List<MeterDto> data) {
                return _meterListWidget(data, selectedMetersCount, false);
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
          ref.read(meterListProvider.notifier).resetAllSelectedMeters();
        },
        style: buttonStyle,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restart_alt,
              size: 28,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Zurücksetzen'),
          ],
        ),
      ),
      TextButton(
        onPressed: () async {
          await ref.read(meterListProvider.notifier).archiveSelectedMeters();
        },
        style: buttonStyle,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.archive_outlined,
              size: 28,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Archivieren'),
          ],
        ),
      ),
      TextButton(
        onPressed: () {
          ref.read(meterListProvider.notifier).deleteAllSelectedMeters();
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

    return SelectedItemsBar(
      buttons: buttons,
    );
  }
}
