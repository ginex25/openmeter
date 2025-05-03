import 'package:flutter/material.dart';
import 'package:openmeter/features/contract/widget/contract_grid.dart';
import 'package:openmeter/features/contract/widget/contract_list_tile.dart';

class ContractView extends StatelessWidget {
  const ContractView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ContractListTile(),
        const ContractGrid(),
      ],
    );
  }
}
