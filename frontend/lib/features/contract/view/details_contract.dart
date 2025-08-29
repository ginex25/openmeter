import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/provider/details_contract_provider.dart';
import 'package:openmeter/features/contract/widget/compare_contracts.dart';
import 'package:openmeter/features/contract/widget/cost_card.dart';
import 'package:openmeter/features/contract/widget/provider_card.dart';
import 'package:openmeter/shared/constant/meter_typ.dart';

import 'add_contract.dart';

class DetailsContractView extends ConsumerStatefulWidget {
  final int contractId;

  const DetailsContractView({super.key, required this.contractId});

  @override
  ConsumerState createState() => _DetailsContractState();
}

class _DetailsContractState extends ConsumerState<DetailsContractView> {
  @override
  Widget build(BuildContext context) {
    final providerData = ref.watch(detailsContractProvider(widget.contractId));

    return providerData.when(
      data: (currentContract) {
        final meterTyp = meterTyps.firstWhere(
            (element) => element.meterTyp == currentContract.meterTyp);

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(meterTyp.providerTitle),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => AddContract(
                          contract: currentContract,
                          fromDetails: true,
                        ),
                      ),
                    )
                        .then((value) {
                      setState(() {
                        if (value != null) {
                          currentContract = value;
                        }
                      });
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CostCard(
                          contract: currentContract,
                        ),
                        if (currentContract.compareCosts != null)
                          CompareContracts(contract: currentContract),
                        const SizedBox(
                          height: 10,
                        ),
                        ProviderCard(
                          provider: currentContract.provider,
                          contract: currentContract,
                        ),
                      ],
                    ),
                  ),
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
}
