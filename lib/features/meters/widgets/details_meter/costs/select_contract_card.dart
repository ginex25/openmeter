import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/provider/contract_list.dart';
import 'package:openmeter/features/meters/provider/current_details_meter.dart';
import 'package:openmeter/features/meters/provider/meter_cost_provider.dart';

import '../../../../contract/model/contract_dto.dart';
import 'select_contract_dialog.dart';

class SelectContractCard extends ConsumerStatefulWidget {
  const SelectContractCard({
    super.key,
  });

  @override
  ConsumerState<SelectContractCard> createState() => _SelectContractCardState();
}

class _SelectContractCardState extends ConsumerState<SelectContractCard> {
  _showSelectionDialog(List<ContractDto> contracts) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return SelectContractDialog(
          contracts: contracts,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ContractDto> contracts = ref.watch(contractsForMeterProvider);

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Es sind zu viele Verträge aktiv.\nWähle einen Vertrag, der zur Berechnung der Kosten genutzt werden soll.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: FilledButton.tonal(
                  onPressed: () async {
                    ContractDto? selectedContract =
                        await _showSelectionDialog(contracts);

                    if (selectedContract != null) {
                      final detailsMeter =
                          ref.watch(currentDetailsMeterProvider);

                      ref
                          .read(meterCostProviderProvider(
                                  detailsMeter.meter, detailsMeter.entries)
                              .notifier)
                          .createMeterCosts(selectedContract, null, null);
                    }
                  },
                  child: const Text('Vertrag wählen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
