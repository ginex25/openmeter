import 'package:drift/drift.dart';
import 'package:openmeter/core/database/model/contract_model.dart';

import '../../../features/contract/model/compare_costs.dart';
import '../../../features/contract/model/contract_dto.dart';
import '../../../features/contract/model/provider_dto.dart';
import '../local_database.dart';
import '../tables/contract.dart';

part 'contract_dao.g.dart';

@DriftAccessor(tables: [Contract, Provider])
class ContractDao extends DatabaseAccessor<LocalDatabase>
    with _$ContractDaoMixin {
  final LocalDatabase db;

  ContractDao(this.db) : super(db);

  Future<int> createProvider(ProviderCompanion provider) async {
    return await db.into(db.provider).insert(provider);
  }

  Future<int> createContract(ContractCompanion contract) async {
    return await db.into(db.contract).insert(contract);
  }

  Stream<List<ContractData>> watchAllContracts(bool isArchived) {
    return (select(db.contract)
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.meterTyp)])
          ..where((tbl) => tbl.isArchived.equals(isArchived)))
        .watch();
  }

  Future<List<ContractModel>> getAllContracts({bool? isArchived}) async {
    final query = select(db.contract).join([
      leftOuterJoin(
          db.provider, db.provider.id.equalsExp(db.contract.provider)),
      leftOuterJoin(
          db.costCompare, db.costCompare.parentId.equalsExp(db.contract.id))
    ])
      ..orderBy([OrderingTerm(expression: db.contract.meterTyp)]);

    if (isArchived != null) {
      query.where(db.contract.isArchived.equals(isArchived));
    }

    return query
        .map((rows) => ContractModel(
              rows.readTable(db.contract),
              rows.readTableOrNull(db.provider),
              rows.readTableOrNull(db.costCompare),
            ))
        .get();
  }

  Future<List<ContractDto>> getAllContractsDto() async {
    List<ContractDto> result = [];
    List<ContractData> contracts = await select(db.contract).get();

    for (ContractData contract in contracts) {
      ContractDto contractDto = ContractDto.fromData(contract, null, null);

      if (contract.provider != null) {
        ProviderData provider = await selectProvider(contract.provider!);

        contractDto.provider = ProviderDto.fromData(provider);
      }

      final compareCosts = await db.costCompareDao.getCompareCost(contract.id);

      if (compareCosts != null) {
        contractDto.compareCosts = CompareCosts.fromData(compareCosts);
      }

      result.add(contractDto);
    }

    return result;
  }

  Future<ProviderData> selectProvider(int id) async {
    return await (db.select(db.provider)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<int> deleteContract(int id) async {
    return await (db.delete(db.contract)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<int> deleteProvider(int id) async {
    return await (db.delete(db.provider)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<List<ContractDto>> getContractByTyp(String meterTyp) async {
    final query = db.select(db.contract).join(
      [
        leftOuterJoin(
          db.provider,
          contract.provider.equalsExp(provider.id),
        ),
      ],
    )..where(
        contract.isArchived.equals(false) & contract.meterTyp.equals(meterTyp));

    return await query
        .map(
          (row) => ContractDto.fromData(
              row.readTable(contract), row.readTableOrNull(provider), null),
        )
        .get();
  }

  Future<ContractDto?> getContractById(int id) {
    final query = db.select(db.contract).join(
      [
        leftOuterJoin(
          db.provider,
          contract.provider.equalsExp(provider.id),
        ),
      ],
    )..where(contract.id.equals(id));

    return query
        .map(
          (row) => ContractDto.fromData(
              row.readTable(contract), row.readTableOrNull(provider), null),
        )
        .getSingleOrNull();
  }

  Future<bool> updateContract(ContractData contractData) async {
    return await update(db.contract).replace(contractData);
  }

  Future<bool> updateProvider(ProviderData providerData) async {
    return await update(db.provider).replace(providerData);
  }

  Future<int?> getTableLength() async {
    var count = db.contract.id.count();

    return await (db.selectOnly(db.contract)..addColumns([count]))
        .map((row) => row.read(count))
        .getSingleOrNull();
  }

  Future<int> linkProviderToContract(
      {required int contractId, required int providerId}) async {
    return await (update(db.contract)
          ..where((tbl) => tbl.id.equals(contractId)))
        .write(
      ContractCompanion(
        provider: Value(providerId),
      ),
    );
  }

  Future<int> updateIsArchived(
      {required int contractId, required bool isArchived}) async {
    return await (update(contract)..where((tbl) => tbl.id.equals(contractId)))
        .write(ContractCompanion(isArchived: Value(isArchived)));
  }

  Future<ContractModel?> findById(int id) async {
    final query = select(db.contract).join([
      leftOuterJoin(
          db.provider, db.provider.id.equalsExp(db.contract.provider)),
      leftOuterJoin(
          db.costCompare, db.costCompare.parentId.equalsExp(db.contract.id))
    ])
      ..where(db.contract.id.equals(id))
      ..orderBy([OrderingTerm(expression: db.contract.meterTyp)]);

    return await query
        .map((rows) => ContractModel(
              rows.readTable(db.contract),
              rows.readTableOrNull(db.provider),
              rows.readTableOrNull(db.costCompare),
            ))
        .getSingleOrNull();
  }
}
