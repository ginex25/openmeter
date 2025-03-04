import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/meters/view/add_meter_screen.dart';
import 'package:openmeter/features/meters/widgets/meter_card_list.dart';
import 'package:openmeter/features/meters/widgets/sort_icon_button.dart';
import 'package:openmeter/ui/widgets/utils/empty_data.dart';
import 'package:openmeter/ui/widgets/utils/selected_items_bar.dart';

class MeterListScreen extends ConsumerStatefulWidget {
  const MeterListScreen({super.key});

  @override
  ConsumerState createState() => _MeterListScreenState();
}

class _MeterListScreenState extends ConsumerState<MeterListScreen> {
  @override
  Widget build(BuildContext context) {
    final int selectedMetersCount = ref.watch(selectedMetersCountProvider);

    final meterProvider = ref.watch(meterListProvider);

    return Scaffold(
      appBar: selectedMetersCount > 0
          ? _selectedAppBar(selectedMetersCount)
          : _unselectedAppBar(),
      body: meterProvider.when(
        data: (List<MeterDto> data) {
          if (data.isEmpty) {
            return const EmptyData();
          }

          return PopScope(
            onPopInvokedWithResult: (bool didPop, _) async {
              if (selectedMetersCount > 0) {
                ref
                    .read(meterListProvider.notifier)
                    .removeAllSelectedMetersState();
              }
            },
            canPop: selectedMetersCount == 0,
            child: Stack(
              children: [
                MeterCardList(
                  meters: data,
                  (MeterDto selectedMeter) {
                    ref
                        .read(meterListProvider.notifier)
                        .toggleMeterSelectedState(selectedMeter);
                  },
                  (MeterDto meter) {
                    ref.read(meterListProvider.notifier).deleteMeter(meter);
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

  AppBar _selectedAppBar(int count) {
    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref.read(meterListProvider.notifier).removeAllSelectedMetersState();
        },
      ),
    );
  }

  AppBar _unselectedAppBar() {
    return AppBar(
      title: const Text('OpenMeter'),
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
        onPressed: () {
          // TODO archiv meters
          // backup.setHasUpdate(true);
          // meterProvider.updateStateArchived(db, true);
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
          // databaseSettingsProvider.setHasUpdate(true);
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
