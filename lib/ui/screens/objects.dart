import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/view/contract_view.dart';
import 'package:provider/provider.dart' as p;

import '../../core/provider/database_settings_provider.dart';
import '../../core/provider/room_provider.dart';
import '../../features/contract/view/add_contract.dart';
import '../widgets/objects_screen/room/add_room.dart';
import '../widgets/objects_screen/room/room_card.dart';
import '../widgets/utils/selected_items_bar.dart';

class ObjectsScreen extends ConsumerStatefulWidget {
  const ObjectsScreen({super.key});

  @override
  ConsumerState<ObjectsScreen> createState() => _ObjectsScreenState();
}

class _ObjectsScreenState extends ConsumerState<ObjectsScreen> {
  final AddRoom _addRoom = AddRoom();

  @override
  void dispose() {
    _addRoom.dispose();
    super.dispose();
  }

  _removeSelectedContracts() {
    ref.read(selectedContractCountProvider.notifier).setSelectedState(0);
    ref.read(contractListProvider.notifier).removeAllSelectedState();
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = p.Provider.of<RoomProvider>(context);

    final int contractSelectedCount = ref.watch(selectedContractCountProvider);

    return Scaffold(
      appBar:
          roomProvider.getStateHasSelected == true || contractSelectedCount > 0
              ? _hasSelectedItems(
                  roomProvider: roomProvider,
                  contractSelectedCount: contractSelectedCount)
              : _noSelectedItems(),
      body: PopScope(
        canPop: !roomProvider.getStateHasSelected && contractSelectedCount == 0,
        onPopInvokedWithResult: (bool didPop, _) async {
          if (roomProvider.getStateHasSelected == true) {
            roomProvider.removeAllSelected();
          }

          if (contractSelectedCount > 0) {
            ref
                .read(selectedContractCountProvider.notifier)
                .setSelectedState(0);
            ref.read(contractListProvider.notifier).removeAllSelectedState();
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Tooltip(
                      message: 'Raum erstellen',
                      child: ListTile(
                        title: Text(
                          'Meine Zimmer',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        trailing: const Icon(Icons.add),
                        onTap: () => _addRoom.getAddRoom(context),
                      ),
                    ),
                    const RoomCard(),
                    const ContractView(),
                    if (contractSelectedCount > 0)
                      const SizedBox(
                        height: 100,
                      ),
                  ],
                ),
              ),
            ),
            if (roomProvider.getStateHasSelected) _selectedRooms(roomProvider),
            if (contractSelectedCount > 0)
              _selectedContract(contractSelectedCount),
          ],
        ),
      ),
    );
  }

  AppBar _noSelectedItems() {
    return AppBar(
      title: const Text('Objekte'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('settings');
          },
          icon: const Icon(Icons.settings),
          tooltip: 'Einstellungen',
        ),
      ],
    );
  }

  _selectedRooms(RoomProvider roomProvider) {
    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).textTheme.bodyLarge!.color,
      ),
    );

    final buttons = [
      TextButton(
        onPressed: () {
          roomProvider.deleteAllSelectedRooms(context);
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

  _selectedContract(int contractSelectedCount) {
    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).textTheme.bodyLarge!.color,
      ),
    );

    final buttons = [
      if (contractSelectedCount == 1)
        TextButton(
          onPressed: () {
            final contract = ref
                .read(contractListProvider.notifier)
                .getSingleSelectedContract();

            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => AddContract(
                contract: contract,
              ),
            ))
                .then(
              (value) {
                _removeSelectedContracts();
              },
            );
          },
          style: buttonStyle,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit_outlined,
                size: 28,
              ),
              SizedBox(
                height: 5,
              ),
              Text('Bearbeiten'),
            ],
          ),
        ),
      TextButton(
        onPressed: () async {
          ref.read(contractListProvider.notifier).archiveAllSelectedContracts();

          if (mounted) {
            p.Provider.of<DatabaseSettingsProvider>(context, listen: false)
                .setHasUpdate(true);
          }
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
          ref.read(contractListProvider.notifier).deleteAllSelectedContracts();

          p.Provider.of<DatabaseSettingsProvider>(context, listen: false)
              .setHasUpdate(true);
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

  AppBar _hasSelectedItems(
      {required RoomProvider roomProvider,
      required int contractSelectedCount}) {
    int count = roomProvider.getSelectedRoomsLength + contractSelectedCount;

    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          if (roomProvider.getStateHasSelected == true) {
            roomProvider.removeAllSelected();
          }

          if (contractSelectedCount > 0) {
            _removeSelectedContracts();
          }
        },
      ),
    );
  }
}
