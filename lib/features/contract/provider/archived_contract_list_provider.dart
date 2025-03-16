import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/model/provider_dto.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:openmeter/features/contract/repository/provider_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archived_contract_list_provider.g.dart';

@riverpod
class ArchivedContractList extends _$ArchivedContractList {
  @override
  FutureOr<List<ContractDto>> build() async {
    final repo = ref.watch(contractRepositoryProvider);

    return await repo.fetchContracts(isArchived: true);
  }

  Future toggleState(ContractDto contract) async {
    if (state.value == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      final allContracts = state.value!;

      int index = allContracts.indexWhere(
        (element) => element.id == contract.id,
      );

      allContracts[index].isSelected = !allContracts[index].isSelected;

      int selectedCount = 0;

      for (ContractDto contract in allContracts) {
        if (contract.isSelected) {
          selectedCount++;
        }
      }

      ref
          .read(selectedContractCountProvider.notifier)
          .setSelectedState(selectedCount);

      return allContracts;
    });
  }

  Future removeAllSelectedState() async {
    if (state.value == null) {
      return;
    }

    state = await AsyncValue.guard(
      () async {
        List<ContractDto> allContracts = state.value!;

        for (ContractDto contract in allContracts) {
          if (contract.isSelected) {
            contract.isSelected = false;
          }
        }

        ref.read(selectedContractCountProvider.notifier).setSelectedState(0);

        return allContracts;
      },
    );
  }

  Future deleteSingleContract(ContractDto contract) async {
    if (state.value == null) {
      return;
    }

    final allContracts = state.value!;

    final repo = ref.watch(contractRepositoryProvider);

    await repo.deleteContract(contract);

    allContracts.removeWhere(
      (element) => element.id == contract.id,
    );

    state = AsyncData(allContracts);
  }

  Future deleteAllSelectedContracts() async {
    if (state.value == null) {
      return null;
    }

    final repo = ref.watch(contractRepositoryProvider);

    List<ContractDto> allContracts = state.value!;

    for (ContractDto contract in allContracts) {
      if (contract.isSelected && contract.id != null) {
        await repo.deleteContract(contract);
      }
    }

    allContracts.removeWhere((element) => element.isSelected);

    ref.read(selectedContractCountProvider.notifier).setSelectedState(0);

    state = AsyncData(allContracts);
  }

  Future unarchiveSingleContract(ContractDto contract) async {
    if (state.value == null) {
      return null;
    }

    final repo = ref.watch(contractRepositoryProvider);

    await repo.toggleArchiveState(contract.id!, false);

    List<ContractDto> allContracts = state.value!;

    allContracts.removeWhere((element) => element.id == contract.id);

    ref.read(selectedContractCountProvider.notifier).setSelectedState(0);
    ref.invalidate(contractListProvider);

    state = AsyncData(allContracts);
  }

  Future unarchiveAllSelectedContracts() async {
    if (state.value == null) {
      return null;
    }

    final repo = ref.watch(contractRepositoryProvider);

    List<ContractDto> allContracts = state.value!;

    for (ContractDto contract in allContracts) {
      if (contract.isSelected && contract.id != null) {
        await repo.toggleArchiveState(contract.id!, false);
      }
    }

    allContracts.removeWhere((element) => element.isSelected);

    ref.read(selectedContractCountProvider.notifier).setSelectedState(0);
    ref.invalidate(contractListProvider);

    state = AsyncData(allContracts);
  }

  Future updateProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    await providerRepo.updateProvider(provider);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(allContracts);
  }

  Future<ProviderDto> removeCanceledState(
      ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    provider.canceled = false;

    await providerRepo.updateProvider(provider);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(allContracts);

    return provider;
  }

  Future deleteProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    await providerRepo.deleteProvider(provider);

    contract.provider = null;

    List<ContractDto> allContracts = state.value!;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(allContracts);
  }

  Future addProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    await providerRepo.createProvider(provider, contract.id);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(allContracts);
  }
}
