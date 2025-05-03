import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/view/contract_view.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/room/provider/search_room_provider.dart';
import 'package:openmeter/features/room/provider/selected_room_count_provider.dart';
import 'package:openmeter/features/room/view/room_view.dart';
import 'package:openmeter/shared/provider/is_searching.dart';
import 'package:openmeter/shared/widgets/search_bar.dart';
import 'package:openmeter/shared/widgets/selected_count_app_bar.dart';

import '../../features/contract/view/add_contract.dart';
import '../../shared/widgets/selected_items_bar.dart';

class ObjectsScreen extends ConsumerStatefulWidget {
  const ObjectsScreen({super.key});

  @override
  ConsumerState<ObjectsScreen> createState() => _ObjectsScreenState();
}

class _ObjectsScreenState extends ConsumerState<ObjectsScreen> {
  _removeSelectedContracts() {
    ref.read(selectedContractCountProvider.notifier).setSelectedState(0);
    ref.read(contractListProvider.notifier).removeAllSelectedState();
  }

  _removeSelectedRooms() {
    ref.read(selectedRoomCountProvider.notifier).setSelectedState(0);
    ref.read(roomListProvider.notifier).removeAllSelectedState();
  }

  @override
  Widget build(BuildContext context) {
    final int contractSelectedCount = ref.watch(selectedContractCountProvider);
    final int roomSelectedCount = ref.watch(selectedRoomCountProvider);
    final bool isSearching = ref.watch(isSearchingProvider);

    return Scaffold(
      appBar: roomSelectedCount > 0 || contractSelectedCount > 0
          ? SelectedCountAppBar(
              count: roomSelectedCount + contractSelectedCount,
              onCancelButton: () {
                if (roomSelectedCount > 0) {
                  _removeSelectedRooms();
                }

                if (contractSelectedCount > 0) {
                  _removeSelectedContracts();
                }
              },
            )
          : SearchAppBar(
              title: 'Object',
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('settings');
                  },
                  icon: const Icon(Icons.settings),
                  tooltip: 'Einstellungen',
                ),
              ],
              onSearch: (searchText) {
                if (searchText.isEmpty) {
                  ref.read(searchRoomProvider.notifier).resetSearchState();
                }

                if (searchText.length > 2) {
                  ref.read(searchRoomProvider.notifier).searchRoom(searchText);
                }
              },
            ),
      body: PopScope(
        canPop: roomSelectedCount == 0 && contractSelectedCount == 0 && !isSearching,
        onPopInvokedWithResult: (bool didPop, _) async {
          if (roomSelectedCount > 0) {
            _removeSelectedRooms();
          }

          if (contractSelectedCount > 0) {
            _removeSelectedContracts();
          }

          if (isSearching) {
            ref.read(isSearchingProvider.notifier).setState(false);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const RoomView(),
                    const ContractView(),
                    if (contractSelectedCount > 0)
                      const SizedBox(
                        height: 100,
                      ),
                  ],
                ),
              ),
            ),
            if (roomSelectedCount > 0) _selectedRooms(),
            if (contractSelectedCount > 0) _selectedContract(contractSelectedCount),
          ],
        ),
      ),
    );
  }

  _selectedRooms() {
    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).textTheme.bodyLarge!.color,
      ),
    );

    final buttons = [
      TextButton(
        onPressed: () async {
          await ref.read(roomListProvider.notifier).deleteAllSelectedContracts();
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
            final contract = ref.read(contractListProvider.notifier).getSingleSelectedContract();

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
}
