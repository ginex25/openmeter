import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/features/contract/helper/contract_helper.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/model/provider_dto.dart';
import 'package:openmeter/features/contract/provider/archived_contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/delete_provider_state.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:openmeter/features/contract/repository/provider_repository.dart';
import 'package:openmeter/features/database_settings/provider/has_update.dart';
import 'package:openmeter/features/meters/provider/contracts_meter_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contract_list_provider.g.dart';

@Riverpod(keepAlive: true)
class ContractList extends _$ContractList {
  @override
  FutureOr<(List<ContractDto>, List<ContractDto>)?> build() async {
    final repo = ref.watch(contractRepositoryProvider);

    final result = await repo.fetchContracts(isArchived: false);

    final helper = ContractHelper();

    return helper.splitContracts(result);
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

      ref.read(selectedContractCountProvider.notifier).setSelectedState(selectedCount);

      final helper = ContractHelper();

      return helper.splitContracts(allContracts);
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

        final helper = ContractHelper();

        return helper.splitContracts(allContracts);
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
    ref.read(hasUpdateProvider.notifier).setState(true);

    final helper = ContractHelper();

    state = AsyncData(helper.splitContracts(allContracts));
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

    ref.invalidate(contractsMeterTypeProvider);
    ref.read(hasUpdateProvider.notifier).setState(true);

    final helper = ContractHelper();

    state = AsyncData(helper.splitContracts(allContracts));
  }

  Future<void> createContract(ContractCompanion companion, ProviderDto? provider) async {
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

    ref.read(hasUpdateProvider.notifier).setState(true);
    ref.invalidate(contractsMeterTypeProvider);

    final helper = ContractHelper();

    state = AsyncData(helper.splitContracts(allContracts));
  }

  Future<ContractDto> updateContract(ContractData contract, ProviderDto? provider) async {
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

    final contractDto = ContractDto.fromData(contract, provider?.toData(), currentDto.compareCosts);

    allContracts[index] = contractDto;

    final helper = ContractHelper();

    state = AsyncData(helper.splitContracts(allContracts));

    ref.invalidate(contractsMeterTypeProvider);
    ref.read(hasUpdateProvider.notifier).setState(true);

    return contractDto;
  }

  Future updateProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    await providerRepo.updateProvider(provider);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    ref.invalidate(contractsMeterTypeProvider);
    ref.read(hasUpdateProvider.notifier).setState(true);

    final helper = ContractHelper();

    state = AsyncData(helper.splitContracts(allContracts));
  }

  Future<ProviderDto> providerRemoveCanceledState(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    provider.canceled = false;

    await providerRepo.updateProvider(provider);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    final helper = ContractHelper();

    state = AsyncData(helper.splitContracts(allContracts));

    return provider;
  }

  Future deleteProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    await providerRepo.deleteProvider(provider);

    contract.provider = null;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;

    ref.invalidate(contractsMeterTypeProvider);
    ref.read(hasUpdateProvider.notifier).setState(true);

    final helper = ContractHelper();

    state = AsyncData(helper.splitContracts(allContracts));
  }

  Future addProvider(ContractDto contract, ProviderDto provider) async {
    final providerRepo = ref.watch(providerRepositoryProvider);

    await providerRepo.createProvider(provider, contract.id);

    contract.provider = provider;

    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    int index = allContracts.indexWhere(
      (element) => element.id == contract.id,
    );

    allContracts[index] = contract;
    ref.read(hasUpdateProvider.notifier).setState(true);

    final helper = ContractHelper();
    state = AsyncData(helper.splitContracts(allContracts));
  }

  addContract(ContractDto newContract) {
    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;
    allContracts.add(newContract);

    final helper = ContractHelper();
    state = AsyncData(helper.splitContracts(allContracts));
  }

  removeContract(ContractDto contract) {
    List<ContractDto> allContracts = state.value!.$1 + state.value!.$2;

    allContracts.removeWhere(
      (element) => element.id == contract.id,
    );

    final helper = ContractHelper();
    state = AsyncData(helper.splitContracts(allContracts));
  }
}
