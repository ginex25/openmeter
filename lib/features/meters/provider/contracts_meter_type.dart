import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contracts_meter_type.g.dart';

@Riverpod(keepAlive: true)
Future<List<ContractDto>> contractsMeterType(Ref ref, String type) async {
  final repo = ref.watch(contractRepositoryProvider);

  return await repo.getContractByType(type);
}
