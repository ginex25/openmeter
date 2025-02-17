import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/meters/widgets/meter_card_list.dart';
import 'package:openmeter/ui/widgets/utils/selected_items_bar.dart';

class MeterListScreen extends ConsumerStatefulWidget {
  const MeterListScreen({super.key});

  @override
  ConsumerState createState() => _MeterListScreenState();
}

class _MeterListScreenState extends ConsumerState<MeterListScreen> {
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(localDbProvider);
    final int selectedMetersCount = ref.watch(selectedMetersCountProvider);

    return Scaffold(
      appBar: selectedMetersCount > 0
          ? _selectedAppBar(selectedMetersCount)
          : _unselectedAppBar(),
      body: PopScope(
        onPopInvokedWithResult: (bool didPop, _) async {
          // if (hasSelectedItems) {
          //   meterProvider.removeAllSelectedMeters();
          // }
        },
        canPop: selectedMetersCount == 0,
        child: Stack(
          children: [
            MeterCardList(
              stream: db.meterDao.watchAllMeterWithRooms(false),
              isHomescreen: true,
            ),
            if (selectedMetersCount > 0) _selectedItems(),
          ],
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
          // meterProvider.removeAllSelectedMeters();
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
            // Navigator.push(
            //   context,
            //   // MaterialPageRoute(
            //       // builder: (context) => const AddScreen(
            //       //   meter: null,
            //       //   room: null,
            //       // ),
            //       // ),
            // );
          },
          icon: const Icon(Icons.add),
          tooltip: 'Zähler erstellen',
        ),
        IconButton(
          onPressed: () {
            // SortMeterCards().getFilter(context: context);
          },
          icon: const Icon(Icons.filter_list),
          tooltip: 'Sortieren',
        ),
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
          // meterProvider.resetSelectedMeters(db);
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
          // meterProvider.deleteSelectedMeters(db);
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
