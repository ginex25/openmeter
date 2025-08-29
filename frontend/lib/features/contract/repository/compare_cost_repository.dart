import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/contract_dao.dart';
import 'package:openmeter/core/database/daos/cost_compare_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/features/contract/model/compare_costs.dart';
import 'package:openmeter/features/contract/model/contract_costs.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compare_cost_repository.g.dart';

class CompareCostRepository {
  final CostCompareDao _compareDao;
  final ContractDao _contractDao;

  CompareCostRepository(this._compareDao, this._contractDao);

  Future<CompareCosts> createCompareCost(CompareCosts compare) async {
    if (compare.parentId == null) {
      throw NullValueException('compare parent id should not be null!');
    }

    final exists = await _compareDao.getCompareCost(compare.parentId!);

    if (exists != null) {
      return CompareCosts.fromData(exists);
    }

    int id =
        await _compareDao.createCompareCost(compare.toCostCompareCompanion());

    compare.id = id;

    return compare;
  }

  Future deleteCompareCost(CompareCosts compare) async {
    if (compare.id == null) {
      throw NullValueException('compare id should not be null!');
    }

    await _compareDao.deleteCompareCost(compare.id!);
  }

  Future<ContractDto> createNewContract(ContractDto currentContract) async {
    final compareCosts = currentContract.compareCosts;

    if (compareCosts == null) {
      throw NullValueException();
    }

    compareCosts.id ??= await _compareDao
        .createCompareCost(compareCosts.toCostCompareCompanion());

    final ContractCosts costs = compareCosts.costs;

    double discount = costs.total! / 12;

    if (costs.bonus != null) {
      double bonus = costs.bonus! / 12;
      discount = discount + bonus;
    }

    costs.discount = discount.roundToDouble();

    final ContractDto newContract = ContractDto(
      costs: costs,
      meterTyp: currentContract.meterTyp,
      isSelected: false,
      unit: currentContract.unit,
    );

    int id = await _contractDao.createContract(newContract.toCompanion());

    await _contractDao.updateIsArchived(
        contractId: currentContract.id!, isArchived: true);

    newContract.id = id;

    return newContract;
  }

  Future<bool> updateCompare(CompareCosts compare) async {
    return await _compareDao.updateCompareCost(compare.toData());
  }
}

@riverpod
CompareCostRepository compareCostRepository(Ref ref) {
  final db = ref.watch(localDbProvider);

  return CompareCostRepository(db.costCompareDao, db.contractDao);
}
