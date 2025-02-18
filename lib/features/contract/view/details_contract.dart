import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/model/contract_dto.dart';
import 'package:openmeter/core/model/provider_dto.dart';
import 'package:openmeter/features/contract/widget/cost_card.dart';
import 'package:openmeter/features/contract/widget/provider_card.dart';
import 'package:openmeter/ui/widgets/objects_screen/contract/compare_contracts.dart';
import 'package:openmeter/utils/meter_typ.dart';

import 'add_contract.dart';

class DetailsContract extends ConsumerStatefulWidget {
  final ContractDto contract;

  const DetailsContract({super.key, required this.contract});

  @override
  ConsumerState createState() => _DetailsContractState();
}

class _DetailsContractState extends ConsumerState<DetailsContract> {
  late ContractDto _currentContract;
  ProviderDto? _currentProvider;

  @override
  void initState() {
    _currentContract = widget.contract;
    _currentProvider = _currentContract.provider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meterTyp = meterTyps
        .firstWhere((element) => element.meterTyp == _currentContract.meterTyp);

    return Scaffold(
      appBar: AppBar(
        title: Text(meterTyp.providerTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => AddContract(
                    contract: _currentContract,
                  ),
                ),
              )
                  .then((value) {
                setState(() {
                  if (value != null) {
                    _currentContract = value;
                    _currentProvider = _currentContract.provider;

                    // TODO: das hier nochmal anschauen
                    // _currentContract.compareCosts = provider.getCompareContract;
                    //
                    // provider.setCurrentProvider(_currentProvider);
                    // provider.setUnit(_currentContract.unit);
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
                  CostCard(contract: _currentContract),
                  if (_currentContract.compareCosts != null)
                    const CompareContracts(),
                  const SizedBox(
                    height: 10,
                  ),
                  ProviderCard(
                    provider: _currentProvider,
                    contract: _currentContract,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
