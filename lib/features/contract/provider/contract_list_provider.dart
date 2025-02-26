import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/model/provider_dto.dart';
import 'package:openmeter/features/contract/provider/archived_contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/delete_provider_state.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:openmeter/features/contract/repository/provider_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contract_list_provider.g.dart';

@Riverpod(keepAlive: true)
class ContractList extends _$ContractList {
  @override
  FutureOr<(List<ContractDto>, List<ContractDto>)?> build() async {
    final repo = ref.watch(contractRepositoryProvider);

    final result = await repo.fetchContracts(false);

    return repo.splitContracts(result);
  }

  Future toggleState(ContractDto contract) async {
    if (state.value == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

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

      final repo = ref.watch(contractRepositoryProvider);

      return repo.splitContracts(allContracts);
    });
  }

  Future removeAllSelectedState() async {
    if (state.value == null) {
      return;
    }

    state = await AsyncValue.guard(
      () async {
        List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

        for (ContractDto contract in allContracts) {
          if (contract.isSelected) {
            contract.isSelected = false;
          }
        }

        final repo = ref.watch(contractRepositoryProvider);

        return repo.splitContracts(allContracts);
      },
    );
  }

  ContractDto? getSingleSelectedContract() {
    if (state.value == null) {
      return null;
    }

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    return allContracts.firstWhere(
      (element) => element.isSelected,
    );
  }

  Future archiveAllSelectedContracts() async {
    if (state.value == null) {
      return null;
    }

    final repo = ref.watch(contractRepositoryProvider);

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    for (ContractDto contract in allContracts) {
      if (contract.isSelected && contract.id != null) {
        await repo.toggleArchiveState(contract.id!, true);
      }
    }

    allContracts.removeWhere((element) => element.isSelected);

    ref.read(selectedContractCountProvider.notifier).setSelectedState(0);
    ref.invalidate(archivedContractListProvider);

    state = AsyncData(repo.splitContracts(allContracts));
  }

  Future deleteAllSelectedContracts() async {
    if (state.value == null) {
      return null;
    }

    final repo = ref.watch(contractRepositoryProvider);

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    for (ContractDto contract in allContracts) {
      if (contract.isSelected && contract.id != null) {
        await repo.deleteContract(contract);
      }
    }

    allContracts.removeWhere((element) => element.isSelected);

    ref.read(selectedContractCountProvider.notifier).setSelectedState(0);

    state = AsyncData(repo.splitContracts(allContracts));
  }

  Future<void> createContract(
      ContractCompanion companion, ProviderDto? provider) async {
    final contractRepo = ref.watch(contractRepositoryProvider);

    final contractDto = await contractRepo.createContract(companion);

    if (provider != null) {
      final providerRepo = ref.watch(providerRepositoryProvider);

      provider = await providerRepo.createProvider(provider, contractDto.id);
    }

    contractDto.provider = provider;

    if (state.value == null) {
      return;
    }

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    allContracts.add(contractDto);

    allContracts.sort(
      (a, b) => a.meterTyp.compareTo(b.meterTyp),
    );

    state = AsyncData(contractRepo.splitContracts(allContracts));
  }

  Future<ContractDto> updateContract(
      ContractData contract, ProviderDto? provider) async {
    final contractRepo = ref.watch(contractRepositoryProvider);
    final providerRepo = ref.watch(providerRepositoryProvider);

    await contractRepo.updateContract(contract);

    final deleteProvider = ref.watch(deleteProviderStateProvider);

    if (deleteProvider && provider != null) {
      await providerRepo.deleteProvider(provider);

      provider = null;

      ref.read(deleteProviderStateProvider.notifier).setState(false);
    }

    if (provider != null && contract.provider != null) {
      await providerRepo.updateProvider(provider);
    }

    if (provider != null && contract.provider == null) {
      await providerRepo.createProvider(provider, contract.id);
    }

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    final currentDto = allContracts[index];

    final contractDto = ContractDto.fromData(
        contract, provider?.toData(), currentDto.compareCosts);

    allContracts[index] = contractDto;

    state = AsyncData(contractRepo.splitContracts(allContracts));

    return contractDto;
  }

  Future updateProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);
    final contractRepo = ref.watch(contractRepositoryProvider);

    await providerRepo.updateProvider(provider);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(contractRepo.splitContracts(allContracts));
  }

  Future<ProviderDto> providerRemoveCanceledState(
      ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);
    final contractRepo = ref.watch(contractRepositoryProvider);

    provider.canceled = false;

    await providerRepo.updateProvider(provider);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(contractRepo.splitContracts(allContracts));

    return provider;
  }

  Future deleteProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);
    final contractRepo = ref.watch(contractRepositoryProvider);

    await providerRepo.deleteProvider(provider);

    contract.provider = null;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(contractRepo.splitContracts(allContracts));
  }

  Future addProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);
    final contractRepo = ref.watch(contractRepositoryProvider);

    await providerRepo.createProvider(provider, contract.id);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    state = AsyncData(contractRepo.splitContracts(allContracts));
  }

  addContract(ContractDto newContract) {
    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;
    allContracts.add(newContract);

    final contractRepo = ref.watch(contractRepositoryProvider);
    state = AsyncData(contractRepo.splitContracts(allContracts));
  }

  removeContract(ContractDto contract) {
    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    allContracts.removeWhere(
      (element) => element.id == contract.id,
    );

    final contractRepo = ref.watch(contractRepositoryProvider);
    state = AsyncData(contractRepo.splitContracts(allContracts));
  }
}
