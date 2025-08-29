import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/contract_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/features/contract/model/provider_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_repository.g.dart';

class ProviderRepository {
  final ContractDao _contractDao;

  ProviderRepository(this._contractDao);

  Future<ProviderDto> createProvider(
      ProviderDto provider, int? contractId) async {
    int providerId = await _contractDao.createProvider(provider.toCompanion());

    if (contractId != null) {
      await _contractDao.linkProviderToContract(
          contractId: contractId, providerId: providerId);
    }

    provider.id = providerId;

    return provider;
  }

  Future deleteProvider(ProviderDto provider) async {
    return await _contractDao.deleteProvider(provider.id!);
  }

  Future updateProvider(ProviderDto provider) async {
    return await _contractDao.updateProvider(provider.toData());
  }
}

@riverpod
ProviderRepository providerRepository(Ref ref) {
  final db = ref.watch(localDbProvider);

  return ProviderRepository(db.contractDao);
}
