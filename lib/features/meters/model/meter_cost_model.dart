import 'package:drift/drift.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';

class MeterCostModel {
  final ContractDto contract;
  final String meterUnit;
  final double totalPaid;
  final double totalCosts;
  final double balance;
  final int sumOfMonths;
  final bool isPredicted;
  final int averageUsage;
  final double averageUsageMonth;
  final DateTime? startDate;
  final DateTime? endDate;

  MeterCostModel({
    required this.contract,
    required this.meterUnit,
    required this.totalPaid,
    required this.totalCosts,
    required this.balance,
    required this.sumOfMonths,
    required this.isPredicted,
    required this.averageUsage,
    required this.averageUsageMonth,
    this.startDate,
    this.endDate,
  });

  MeterCostModel copyWith({
    ContractDto? contract,
    String? meterUnit,
    double? totalPaid,
    double? totalCosts,
    double? balance,
    int? sumOfMonths,
    bool? isPredicted,
    int? averageUsage,
    double? averageUsageMonth,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      MeterCostModel(
        contract: contract ?? this.contract,
        meterUnit: meterUnit ?? this.meterUnit,
        totalPaid: totalPaid ?? this.totalPaid,
        totalCosts: totalCosts ?? this.totalCosts,
        balance: balance ?? this.balance,
        sumOfMonths: sumOfMonths ?? this.sumOfMonths,
        isPredicted: isPredicted ?? this.isPredicted,
        averageUsage: averageUsage ?? this.averageUsage,
        averageUsageMonth: averageUsageMonth ?? this.averageUsageMonth,
        startDate: startDate,
        endDate: endDate,
      );

  MeterContractCompanion toCompanion() => MeterContractCompanion(
        endDate: Value(endDate),
        startDate: Value(startDate),
        contractId: Value(contract.id!),
      );
}
