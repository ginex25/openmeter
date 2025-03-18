import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/meters/model/meter_cost_model.dart';
import 'package:openmeter/features/meters/provider/contract_list.dart';
import 'package:openmeter/features/meters/provider/current_details_meter.dart';
import 'package:openmeter/features/meters/provider/meter_cost_provider.dart';
import 'package:openmeter/features/meters/widgets/details_meter/costs/select_contract_dialog.dart';

enum CostOverviewOperator { changeContract, selectTimeSpan, removeTimeSpan }

class CostHeadline extends ConsumerStatefulWidget {
  final MeterCostModel? meterCost;

  const CostHeadline({super.key, this.meterCost});

  @override
  ConsumerState createState() => _CostHeadlineState();
}

class _CostHeadlineState extends ConsumerState<CostHeadline> {
  _hintText(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.only(left: 24, right: 24),
        title: const Text('Informationen'),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
        content: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.sizeOf(context).width,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Alle errechneten Werte sind nur eine grobe Schätzung der App und spiegeln nicht den tatsächlichen Verbrauch oder Kosten wieder.'),
                Divider(),
                Text(
                  'Sollte kein Zeitraum ausgewählt sein, werden die Kosten für die gesamte Zeit berechnet.',
                ),
                Divider(),
                Text(
                    'Sollte ein Zeitraum ausgewählt sein, aber die Einträge beginnen oder enden vor dem gewählten Zeitraum, '
                    'so wird der Verbrauch für die restliche Zeit anhand der vorhandenen Einträge geschätzt.'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  _showSelectContractDialog() async {
    List<ContractDto> contracts = ref.watch(contractsForMeterProvider);

    ContractDto? result = await showDialog(
      context: context,
      builder: (context) => SelectContractDialog(
          contracts: contracts,
          selectedContractId: widget.meterCost?.contract.id),
    );

    final detailsMeter = ref.watch(currentDetailsMeterProvider);

    if (result != null) {
      ref
          .read(meterCostProviderProvider(
                  detailsMeter.meter, detailsMeter.entries)
              .notifier)
          .updateContract(result);
    }
  }

  _showSelectDateRange() async {
    final today = DateTime.now();

    DateTimeRange? initialRange;
    if (widget.meterCost?.startDate != null &&
        widget.meterCost?.endDate != null) {
      initialRange = DateTimeRange(
          start: widget.meterCost!.startDate!, end: widget.meterCost!.endDate!);
    }

    final DateTimeRange? result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(today.year - 10),
        lastDate: DateTime(today.year + 10),
        currentDate: today,
        initialDateRange: initialRange);

    if (result != null) {
      final detailsMeter = ref.watch(currentDetailsMeterProvider);

      ref
          .read(meterCostProviderProvider(
                  detailsMeter.meter, detailsMeter.entries)
              .notifier)
          .updateDateRange(result.start, result.end);
    }
  }

  PopupMenuButton _popupMenuButtons() {
    String timeRangeText = 'Zeitraum wählen';

    if (widget.meterCost?.startDate != null &&
        widget.meterCost?.endDate != null) {
      timeRangeText = 'Zeitraum ändern';
    }

    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      icon: const Icon(
        Icons.more_horiz,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: CostOverviewOperator.changeContract,
          child: Row(
            children: [
              const Icon(
                Icons.swap_horiz,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Vertrag wechseln',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: CostOverviewOperator.selectTimeSpan,
          child: Row(
            children: [
              const Icon(
                Icons.date_range,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                timeRangeText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        if (widget.meterCost?.startDate != null &&
            widget.meterCost?.endDate != null)
          PopupMenuItem(
            value: CostOverviewOperator.removeTimeSpan,
            child: Row(
              children: [
                const Icon(
                  Icons.event_busy,
                  size: 20,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  'Zeitraum löschen',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
      onSelected: (value) async {
        switch (value) {
          case CostOverviewOperator.changeContract:
            await _showSelectContractDialog();
            break;
          case CostOverviewOperator.selectTimeSpan:
            await _showSelectDateRange();
            break;
          case CostOverviewOperator.removeTimeSpan:
            final detailsMeter = ref.watch(currentDetailsMeterProvider);

            ref
                .read(meterCostProviderProvider(
                        detailsMeter.meter, detailsMeter.entries)
                    .notifier)
                .updateDateRange(null, null);
            break;
          default:
            log('No CostOverviewOperator found!');
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Kostenübersicht',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                _hintText(context);
              },
            ),
            _popupMenuButtons(),
          ],
        ),
      ],
    );
  }
}
