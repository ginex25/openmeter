import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/features/contract/model/compare_costs.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/repository/compare_cost_repository.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../database_settings/provider/has_update.dart';

part 'details_contract_provider.g.dart';

@riverpod
class DetailsContract extends _$DetailsContract {
  @override
  Future<ContractDto> build(int id) async {
    final ContractRepository repo = ref.watch(contractRepositoryProvider);

    return await repo.getById(id);
  }

  updateContract(ContractDto contract) {
    state = AsyncData(contract);
  }

  saveCompareCosts() async {
    final repo = ref.watch(compareCostRepositoryProvider);

    final currentContract = state.value!;

    if (currentContract.compareCosts == null) {
      throw NullValueException();
    }

    final compare = await repo.createCompareCost(currentContract.compareCosts!);

    currentContract.compareCosts = compare;

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(currentContract);
  }

  addCompareCosts(CompareCosts compareCosts) {
    final currentContract = state.value!;

    currentContract.compareCosts = compareCosts;

    state = AsyncData(currentContract);
  }

  updateCompareCost(CompareCosts compareCosts) async {
    final currentContract = state.value!;

    currentContract.compareCosts = compareCosts;

    if (compareCosts.id != null) {
      final repo = ref.watch(compareCostRepositoryProvider);

      await repo.updateCompare(compareCosts);
    }

    ref.read(hasUpdateProvider.notifier).setState(true);

    currentContract.compareCosts = compareCosts;
    state = AsyncData(currentContract);
  }

  deleteCompareCosts() async {
    final repo = ref.watch(compareCostRepositoryProvider);

    final currentContract = state.value!;

    await repo.deleteCompareCost(currentContract.compareCosts!);

    currentContract.compareCosts = null;

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(currentContract);
  }

  Future createNewContractFromCompare() async {
    final repo = ref.watch(compareCostRepositoryProvider);

    final newContract = await repo.createNewContract(state.value!);

    ref.read(contractListProvider.notifier).addContract(newContract);
    ref.read(contractListProvider.notifier).removeContract(state.value!);
    ref.read(hasUpdateProvider.notifier).setState(true);
  }
}
