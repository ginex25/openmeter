import 'package:openmeter/core/database/local_database.dart';

class ContractModel {
  final ContractData contractData;
  final ProviderData? providerData;
  final CostCompareData? costCompareData;

  ContractModel(this.contractData, this.providerData, this.costCompareData);
}
