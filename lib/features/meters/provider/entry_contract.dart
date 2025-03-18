import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/repository/meter_cost_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../contract/model/contract_dto.dart';

part 'entry_contract.g.dart';

@riverpod
Future<ContractDto?> entryContract(Ref ref, MeterDto meter) async {
  final MeterCostRepository repo = ref.watch(meterCostRepositoryProvider);

  return await repo.fetchContractForEntry(meter);
}
