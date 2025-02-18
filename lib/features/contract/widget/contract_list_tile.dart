import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/view/add_contract.dart';

class ContractListTile extends ConsumerWidget {
  const ContractListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedContractCount = ref.watch(selectedContractCountProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Meine Verträge',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (selectedContractCount > 0) {
                    ref
                        .read(contractListProvider.notifier)
                        .removeAllSelectedState();
                  }
                  Navigator.of(context).pushNamed('archive_contract');
                },
                icon: const Icon(Icons.archive_outlined),
                tooltip: 'Archivierte Verträge anzeigen',
              ),
              IconButton(
                // TODO: check ob contract liste aktualisiert wird
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddContract(contract: null),
                  ),
                ),
                icon: const Icon(Icons.add),
                tooltip: 'Vertrag erstellen',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
