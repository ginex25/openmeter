import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:openmeter/features/contract/provider/archived_contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/widget/contract_card.dart';
import 'package:provider/provider.dart' as p;

import '../../../core/provider/database_settings_provider.dart';
import '../../../ui/widgets/utils/empty_archiv.dart';
import '../../../ui/widgets/utils/selected_items_bar.dart';
import '../../../utils/custom_colors.dart';
import '../model/contract_dto.dart';
import 'details_contract.dart';

class ArchiveContract extends ConsumerStatefulWidget {
  const ArchiveContract({super.key});

  @override
  ConsumerState<ArchiveContract> createState() => _ArchiveContractState();
}

class _ArchiveContractState extends ConsumerState<ArchiveContract> {
  @override
  Widget build(BuildContext context) {
    int hasSelectedItems = ref.watch(selectedContractCountProvider);

    final archiveItemsProvider = ref.watch(archivedContractListProvider);

    return Scaffold(
      appBar: hasSelectedItems > 0
          ? _selectedAppBar(hasSelectedItems)
          : AppBar(
              title: const Text('Archivierte Verträge'),
            ),
      body: PopScope(
        canPop: hasSelectedItems == 0,
        onPopInvokedWithResult: (bool didPop, _) async {
          if (hasSelectedItems > 0) {
            ref
                .read(archivedContractListProvider.notifier)
                .removeAllSelectedState();
          }
        },
        child: Stack(
          children: [
            archiveItemsProvider.when(
              data: (data) {
                if (data.isEmpty) {
                  return const EmptyArchiv(
                      titel: 'Es wurden noch keine Verträge archiviert.');
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final contract = data.elementAt(index);

                    if (hasSelectedItems > 0) {
                      return GestureDetector(
                        onLongPress: () {
                          ref
                              .read(archivedContractListProvider.notifier)
                              .toggleState(contract);
                        },
                        onTap: () {
                          if (hasSelectedItems > 0) {
                            ref
                                .read(archivedContractListProvider.notifier)
                                .toggleState(contract);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return DetailsContractView(
                                    contractId: contract.id!);
                              }),
                            );
                          }
                        },
                        child: ContractCard(
                          contractDto: contract,
                        ),
                      );
                    } else {
                      return _slideCard(
                        contract: contract,
                        hasSelectedItems: hasSelectedItems,
                      );
                    }
                  },
                );
              },
              error: (error, stackTrace) => throw error,
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            if (hasSelectedItems > 0) _selectedItemsBar(),
          ],
        ),
      ),
    );
  }

  _slideCard({required ContractDto contract, required int hasSelectedItems}) {
    final autoBackup =
        p.Provider.of<DatabaseSettingsProvider>(context, listen: false);

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              ref
                  .read(archivedContractListProvider.notifier)
                  .deleteSingleContract(contract);

              if (context.mounted) {
                autoBackup.setHasUpdate(true);
              }
            },
            icon: Icons.delete,
            label: 'Löschen',
            backgroundColor: CustomColors.red,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              ref
                  .read(archivedContractListProvider.notifier)
                  .unarchiveSingleContract(contract);

              if (context.mounted) {
                autoBackup.setHasUpdate(true);
              }
            },
            icon: Icons.unarchive,
            label: 'Wiederherstellen',
            foregroundColor: Colors.white,
            backgroundColor: CustomColors.blue,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: () {
          ref.read(archivedContractListProvider.notifier).toggleState(contract);
        },
        onTap: () {
          if (hasSelectedItems > 0) {
            ref
                .read(archivedContractListProvider.notifier)
                .toggleState(contract);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return DetailsContractView(contractId: contract.id!);
              }),
            );
          }
        },
        child: ContractCard(contractDto: contract),
      ),
    );
  }

  _selectedItemsBar() {
    final backupProvider =
        p.Provider.of<DatabaseSettingsProvider>(context, listen: false);

    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).textTheme.bodyLarge!.color,
      ),
    );

    final buttons = [
      TextButton(
        onPressed: () async {
          ref
              .read(archivedContractListProvider.notifier)
              .unarchiveAllSelectedContracts();

          if (mounted) {
            backupProvider.setHasUpdate(true);
          }
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
        onPressed: () async {
          await ref
              .read(archivedContractListProvider.notifier)
              .deleteAllSelectedContracts();

          backupProvider.setHasUpdate(true);
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

  _selectedAppBar(int count) {
    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref
              .read(archivedContractListProvider.notifier)
              .removeAllSelectedState();
        },
      ),
    );
  }
}
