import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../helper/contract_helper.dart';

part 'search_contract_provider.g.dart';

@riverpod
class SearchContract extends _$SearchContract {
  @override
  (List<ContractDto>, List<ContractDto>)? build() {
    return null;
  }

  void searchContract(String searchText) {
    final (List<ContractDto>, List<ContractDto>)? currentContracts = ref.watch(contractListProvider).value;

    if (currentContracts == null) {
      return;
    }
    final helper = ContractHelper();
    state = helper.searchContract(searchText, currentContracts.$1 + currentContracts.$2);
  }

  void resetSearchState() {
    state = null;
  }
}
