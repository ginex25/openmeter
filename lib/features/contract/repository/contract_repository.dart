import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/contract_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/database/model/contract_model.dart';
import 'package:openmeter/features/contract/model/compare_costs.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contract_repository.g.dart';

class ContractRepository {
  final ContractDao _contractDao;

  ContractRepository(this._contractDao);

  Future<List<ContractDto>> fetchContracts(bool isArchived) async {
    final List<ContractModel> data =
        await _contractDao.getAllContracts(isArchived);

    if (data.isEmpty) {
      return [];
    }

    final result = data.map(
      (e) {
        final CompareCosts? costs = e.costCompareData == null
            ? null
            : CompareCosts.fromData(e.costCompareData!);

        return ContractDto.fromData(e.contractData, e.providerData, costs);
      },
    );

    return result.toList();
  }

  (List<ContractDto>, List<ContractDto>) splitContracts(
      Iterable<ContractDto> contracts) {
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

  Future toggleArchiveState(int contractId, bool isArchived) async {
    return await _contractDao.updateIsArchived(
        contractId: contractId, isArchived: isArchived);
  }

  Future deleteContract(ContractDto contract) async {
    if (contract.provider != null) {
      await _contractDao.deleteProvider(contract.provider!.id!);
    }

    await _contractDao.deleteContract(contract.id!);
  }

  Future<ContractDto> createContract(ContractCompanion contract) async {
    final int contractId = await _contractDao.createContract(contract);

    ContractDto contractDto =
        ContractDto.fromCompanion(data: contract, contractId: contractId);

    return contractDto;
  }

  Future updateContract(ContractData data) async {
    await _contractDao.updateContract(data);
  }

  Future<ContractDto> getById(int id) async {
    final ContractModel? data = await _contractDao.findById(id);

    if (data == null) {
      throw 'Contract with id $id not found!';
    }

    final CompareCosts? costs = data.costCompareData == null
        ? null
        : CompareCosts.fromData(data.costCompareData!);

    return ContractDto.fromData(data.contractData, data.providerData, costs);
  }

  Future<List<ContractDto>> getContractByType(String type) async {
    return await _contractDao.getContractByTyp(type);
  }
}

@riverpod
ContractRepository contractRepository(Ref ref) {
  final LocalDatabase db = ref.watch(localDbProvider);

  return ContractRepository(db.contractDao);
}
