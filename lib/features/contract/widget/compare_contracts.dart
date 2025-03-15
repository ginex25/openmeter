import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/enums/compare_costs_menu.dart';
import 'package:openmeter/features/contract/helper/calc_compare_values.dart';
import 'package:openmeter/features/contract/model/compare_costs.dart';
import 'package:openmeter/features/contract/model/contract_costs.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/provider/details_contract_provider.dart';
import 'package:openmeter/features/contract/widget/add_costs.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

// Todo checken ob es im archiv auch noch geht, Lösung finden um mit Archiv besser um zu gehen
class CompareContracts extends StatefulWidget {
  final ContractDto contract;

  const CompareContracts({super.key, required this.contract});

  @override
  State<CompareContracts> createState() => _CompareContractsState();
}

class _CompareContractsState extends State<CompareContracts> {
  @override
  Widget build(BuildContext context) {
    final compareCosts = widget.contract.compareCosts;

    final compareValuesHelper = CalcCompareValues(
        compareCost: compareCosts!, currentCost: widget.contract.costs);

    final ContractCosts compareValues = compareValuesHelper.compareCosts();

    compareCosts.costs.total = compareValuesHelper.getCompareTotal();

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kosten Vergleichen',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  CompareContractPopupMenu(
                    contract: widget.contract,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              CompareContractsTable(
                compareContract: compareCosts,
                compareValues: compareValues,
                unit: widget.contract.unit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompareContractsTable extends StatefulWidget {
  final ContractCosts compareValues;
  final CompareCosts compareContract;
  final String unit;

  const CompareContractsTable({
    super.key,
    required this.compareValues,
    required this.compareContract,
    required this.unit,
  });

  @override
  State<CompareContractsTable> createState() => _CompareContractsTableState();
}

class _CompareContractsTableState extends State<CompareContractsTable> {
  final String local = Platform.localeName;

  final ConvertMeterUnit convertMeterUnit = ConvertMeterUnit();

  _createTableRows({
    required String title,
    required double newValue,
    required double difference,
    double padding = 0,
    required String local,
  }) {
    final formatSimpleCurrency = NumberFormat.simpleCurrency(locale: local);

    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, top: padding),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, top: padding),
            child: Text(
              formatSimpleCurrency.format(newValue),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5, top: padding),
            child: Text(
              formatSimpleCurrency.format(difference),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatDecimal =
        NumberFormat.decimalPatternDigits(locale: local, decimalDigits: 2);

    ContractCosts compareValues = widget.compareValues;
    CompareCosts compareContract = widget.compareContract;

    final costs = compareContract.costs;

    return Table(
      columnWidths: const {
        0: FractionColumnWidth(0.4),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  'Verbrauch',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  '${compareContract.usage} ${convertMeterUnit.getUnitString(widget.unit)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const TableCell(
              child: Text(''),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  '',
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'Neue Kosten',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            TableCell(
              child: Text(
                'Ersparnisse',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        _createTableRows(
          title: 'Grundpreis',
          difference: compareValues.basicPrice,
          newValue: costs.basicPrice,
          local: local,
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'Arbeitspreis',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '${formatDecimal.format(costs.energyPrice)} Cent',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            TableCell(
              child: Text(
                '${formatDecimal.format(compareValues.energyPrice)} Cent',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        _createTableRows(
          title: 'Bonus',
          difference: compareValues.bonus?.toDouble() ?? 0.0,
          newValue: costs.bonus?.toDouble() ?? 0.0,
          local: local,
        ),
        _createTableRows(
            title: 'pro Monat',
            difference: compareValues.total! / 12,
            newValue: compareContract.costs.total! / 12,
            local: local,
            padding: 10),
      ],
    );
  }
}

class CompareContractPopupMenu extends ConsumerStatefulWidget {
  final ContractDto contract;

  const CompareContractPopupMenu({super.key, required this.contract});

  @override
  ConsumerState<CompareContractPopupMenu> createState() =>
      _CompareContractPopupMenuState();
}

class _CompareContractPopupMenuState
    extends ConsumerState<CompareContractPopupMenu> {
  late ContractDto contract;

  _openBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 500,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Vergleichsdaten bearbeiten',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AddCosts(contract: contract),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    contract = widget.contract;

    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (value) async {
        switch (value) {
          case CompareCostsMenu.save:
            await ref
                .read(detailsContractProvider(contract.id!).notifier)
                .saveCompareCosts();
            break;
          case CompareCostsMenu.delete:
            await ref
                .read(detailsContractProvider(contract.id!).notifier)
                .deleteCompareCosts();
            break;
          case CompareCostsMenu.newContract:
            await ref
                .read(detailsContractProvider(contract.id!).notifier)
                .createNewContractFromCompare()
                .then(
              (value) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'Neuer Vertrag wurde erstellt!',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
            );
            break;
          case CompareCostsMenu.edit:
            _openBottomSheet(context);
            break;
        }

        // Provider.of<DatabaseSettingsProvider>(context, listen: false)
        //     .setHasUpdate(true);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: CompareCostsMenu.newContract,
          child: Row(
            children: [
              const Icon(
                Icons.add,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Neuer Vertrag',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: CompareCostsMenu.save,
          child: Row(
            children: [
              const Icon(
                Icons.push_pin,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Zwischenspeichern',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: CompareCostsMenu.edit,
          child: Row(
            children: [
              const Icon(
                Icons.edit,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Bearbeiten',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: CompareCostsMenu.delete,
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Löschen',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(context).indicatorColor,
      ),
    );
  }
}
