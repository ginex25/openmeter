import 'package:flutter/material.dart';
import 'package:openmeter/features/contract/view/add_contract.dart';
import 'package:provider/provider.dart';

import '../../../core/model/contract_dto.dart';
import '../../../core/model/provider_dto.dart';
import '../../../core/provider/details_contract_provider.dart';
import '../../../ui/widgets/objects_screen/contract/compare_contracts.dart';
import '../../../utils/meter_typ.dart';
import '../widget/cost_card.dart';

class DetailsContractOld extends StatefulWidget {
  final ContractDto contract;

  const DetailsContractOld({super.key, required this.contract});

  @override
  State<DetailsContractOld> createState() => _DetailsContractOldState();
}

class _DetailsContractOldState extends State<DetailsContractOld> {
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
    final provider = Provider.of<DetailsContractProvider>(context);

    if (_currentContract.compareCosts != null) {
      provider.setCompareContract(_currentContract.compareCosts, false);
    }

    _currentProvider = provider.getCurrentProvider;

    if (_currentProvider != null && _currentContract.provider == null) {
      _currentContract.provider = _currentProvider;
    }

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

                    _currentContract.compareCosts = provider.getCompareContract;

                    provider.setCurrentProvider(_currentProvider);
                    provider.setUnit(_currentContract.unit);
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
                spacing: 10,
                children: [
                  CostCard(contract: _currentContract),
                  if (provider.getCompareContract != null)
                    const CompareContracts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
