import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/meters/model/meter_cost_model.dart';
import 'package:openmeter/features/meters/repository/meter_cost_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meter_cost_provider.g.dart';

@Riverpod(keepAlive: true)
class MeterCostProvider extends _$MeterCostProvider {
  @override
  FutureOr<MeterCostModel?> build(
      MeterDto meter, List<EntryDto> entries) async {
    final MeterCostRepository repo = ref.watch(meterCostRepositoryProvider);

    return await repo.fetchCostsData(meter, entries);
  }

  Future<void> createMeterCosts(
      ContractDto contract, DateTime? startDate, DateTime? endDate) async {
    final MeterCostRepository repo = ref.watch(meterCostRepositoryProvider);

    state = await AsyncValue.guard(
      () async {
        return await repo.createMeterCost(
            meter: meter,
            contract: contract,
            entries: entries,
            startDate: startDate,
            endDate: endDate);
      },
    );
  }

  Future<void> updateContract(ContractDto contract) async {
    final MeterCostRepository repo = ref.watch(meterCostRepositoryProvider);

    final newCosts = await repo.updateMeterContract(
        meterCost: state.value!,
        newContract: contract,
        meterId: meter.id!,
        entries: entries);

    state = AsyncData(newCosts);
  }

  Future<void> updateDateRange(DateTime? startDate, DateTime? endDate) async {
    final MeterCostRepository repo = ref.watch(meterCostRepositoryProvider);

    final newCosts = await repo.updateDateRange(
      meterCost: state.value!,
      meterId: meter.id!,
      entries: entries,
      endDate: endDate,
      startDate: startDate,
    );

    state = AsyncData(newCosts);
  }
}
