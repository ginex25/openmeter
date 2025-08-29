import 'package:collection/collection.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';

class ContractHelper {
  (List<ContractDto>, List<ContractDto>) splitContracts(Iterable<ContractDto> contracts) {
    contracts = contracts.sortedBy(
      (element) {
        return element.meterTyp;
      },
    );

    List<ContractDto> firstRow = [];
    List<ContractDto> secondRow = [];

    for (int i = 0; i < contracts.length; i++) {
      if (i % 2 == 0) {
        firstRow.add(contracts.elementAt(i));
      } else {
        secondRow.add(contracts.elementAt(i));
      }
    }

    return (firstRow, secondRow);
  }

  (List<ContractDto>, List<ContractDto>)? searchContract(String searchText, List<ContractDto> contracts) {
    if (contracts.isEmpty) {
      return ([], []);
    }

    final List<ContractDto> result = [];

    for (ContractDto contract in contracts) {
      final lowerSearch = searchText.toLowerCase();
      final meterTypeMatch = contract.meterTyp.toLowerCase().contains(lowerSearch);

      final provider = contract.provider;
      final providerNameMatch = provider?.name.toLowerCase().contains(lowerSearch) ?? false;
      final contractNumberMatch = provider?.contractNumber.toLowerCase().contains(lowerSearch) ?? false;

      if (meterTypeMatch || providerNameMatch || contractNumberMatch) {
        result.add(contract);
      }
    }

    return splitContracts(result);
  }
}
