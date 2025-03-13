import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/meter_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:openmeter/features/meters/helper/cost_helper.dart';
import 'package:openmeter/features/meters/model/meter_cost_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meter_cost_repository.g.dart';

class MeterCostRepository {
  final MeterDao _meterDao;
  final ContractRepository _contractRepository;

  MeterCostRepository(this._meterDao, this._contractRepository);

  Future<ContractDto?> fetchContractForEntry(MeterDto meter) async {
    final MeterContractData? meterContractData =
        await _meterDao.getMeterContract(meter.id!);

    if (meterContractData == null) {
      return null;
    }

    return await _contractRepository.getById(meterContractData.contractId);
  }

  Future<MeterCostModel?> fetchCostsData(
      MeterDto meter, List<EntryDto> entries) async {
    final MeterContractData? meterContractData =
        await _meterDao.getMeterContract(meter.id!);

    if (meterContractData == null) {
      return null;
    }

    final ContractDto contract =
        await _contractRepository.getById(meterContractData.contractId);

    final CostHelper costHelper = CostHelper();

    costHelper.entries = entries;
    costHelper.basicPrice = contract.costs.basicPrice;
    costHelper.discount = contract.costs.discount;
    costHelper.energyPrice = contract.costs.energyPrice;

    costHelper.initialCalc(
        costFrom: meterContractData.startDate,
        costUntil: meterContractData.endDate);

    final MeterCostModel meterCostModel = MeterCostModel(
        contract: contract,
        meterUnit: meter.unit,
        totalPaid: costHelper.totalPaid,
        totalCosts: costHelper.totalCosts,
        balance: costHelper.difference,
        sumOfMonths: costHelper.months,
        isPredicted: costHelper.isPredicted,
        averageUsage: costHelper.averageUsage,
        averageUsageMonth: costHelper.averageMonth,
        startDate: meterContractData.startDate,
        endDate: meterContractData.endDate);

    return meterCostModel;
  }

  Future<MeterCostModel> createMeterCost({
    required MeterDto meter,
    required ContractDto contract,
    DateTime? startDate,
    DateTime? endDate,
    required List<EntryDto> entries,
  }) async {
    await _meterDao.createMeterContract(
        meter.id!, contract.id!, startDate, endDate);

    final CostHelper costHelper = CostHelper();
    costHelper.entries = entries;
    costHelper.basicPrice = contract.costs.basicPrice;
    costHelper.discount = contract.costs.discount;
    costHelper.energyPrice = contract.costs.energyPrice;

    costHelper.initialCalc(costFrom: startDate, costUntil: endDate);

    final MeterCostModel meterCostModel = MeterCostModel(
        contract: contract,
        meterUnit: meter.unit,
        totalPaid: costHelper.totalPaid,
        totalCosts: costHelper.totalCosts,
        balance: costHelper.difference,
        sumOfMonths: costHelper.months,
        isPredicted: costHelper.isPredicted,
        averageUsage: costHelper.averageUsage,
        averageUsageMonth: costHelper.averageMonth,
        startDate: startDate,
        endDate: endDate);

    return meterCostModel;
  }

  Future<MeterCostModel> updateMeterContract(
      {required MeterCostModel meterCost,
      required ContractDto newContract,
      required List<EntryDto> entries,
      required int meterId}) async {
    if (newContract.id == meterCost.contract.id) {
      return meterCost;
    }
    final CostHelper costHelper = CostHelper();

    costHelper.entries = entries;
    costHelper.basicPrice = newContract.costs.basicPrice;
    costHelper.discount = newContract.costs.discount;
    costHelper.energyPrice = newContract.costs.energyPrice;

    costHelper.initialCalc(
        costFrom: meterCost.startDate, costUntil: meterCost.endDate);

    final MeterCostModel meterCostModel = meterCost.copyWith(
      totalPaid: costHelper.totalPaid,
      totalCosts: costHelper.totalCosts,
      balance: costHelper.difference,
      sumOfMonths: costHelper.months,
      isPredicted: costHelper.isPredicted,
      averageUsage: costHelper.averageUsage,
      averageUsageMonth: costHelper.averageMonth,
      contract: newContract,
    );

    await _meterDao.updateContractForMeter(
        meterId, meterCostModel.toCompanion());

    return meterCostModel;
  }

  Future<MeterCostModel> updateDateRange(
      {required MeterCostModel meterCost,
      required List<EntryDto> entries,
      required int meterId,
      DateTime? startDate,
      DateTime? endDate}) async {
    final contract = meterCost.contract;

    final CostHelper costHelper = CostHelper();

    costHelper.entries = entries;
    costHelper.basicPrice = contract.costs.basicPrice;
    costHelper.discount = contract.costs.discount;
    costHelper.energyPrice = contract.costs.energyPrice;
    costHelper.isPredicted = false;

    costHelper.initialCalc(costFrom: startDate, costUntil: endDate);

    final MeterCostModel meterCostModel = meterCost.copyWith(
      totalPaid: costHelper.totalPaid,
      totalCosts: costHelper.totalCosts,
      balance: costHelper.difference,
      sumOfMonths: costHelper.months,
      isPredicted: costHelper.isPredicted,
      averageUsage: costHelper.averageUsage,
      averageUsageMonth: costHelper.averageMonth,
      contract: contract,
      startDate: startDate,
      endDate: endDate,
    );

    await _meterDao.updateContractForMeter(
        meterId, meterCostModel.toCompanion());

    return meterCostModel;
  }
}

@riverpod
MeterCostRepository meterCostRepository(Ref ref) {
  final db = ref.watch(localDbProvider);

  return MeterCostRepository(
      db.meterDao, ref.watch(contractRepositoryProvider));
}
