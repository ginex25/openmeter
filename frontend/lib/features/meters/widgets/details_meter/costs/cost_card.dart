import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/features/meters/model/meter_cost_model.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

import '../../../../../shared/constant/custom_icons.dart';

class CostCard extends ConsumerStatefulWidget {
  final MeterCostModel meterCosts;

  const CostCard(this.meterCosts, {super.key});

  @override
  ConsumerState createState() => _CostCardState();
}

class _CostCardState extends ConsumerState<CostCard> {
  late NumberFormat _costFormat;

  late TextStyle _labelStyle;
  late TextStyle _bodyStyle;

  late MeterCostModel meterCosts;

  final DateFormat _dateFormat = DateFormat(DateTimeFormats.dateGermanLong);

  @override
  Widget build(BuildContext context) {
    final String local = Platform.localeName;
    _costFormat = NumberFormat.simpleCurrency(locale: local);

    _labelStyle = Theme.of(context).textTheme.labelSmall!;
    _bodyStyle = Theme.of(context).textTheme.bodyMedium!;

    meterCosts = widget.meterCosts;

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (meterCosts.startDate != null && meterCosts.endDate != null)
                _tableSelectedTimeRange(),
              meterCosts.isPredicted
                  ? _tablePredictedTotalCosts()
                  : _tableTotalCosts(),
              const SizedBox(
                height: 15,
              ),
              _tableTotalPaid(),
            ],
          ),
        ),
      ),
    );
  }

  _tableTotalCosts() {
    return Column(
      children: [
        Text(
          'Verbraucht',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Table(
          children: [
            TableRow(
              children: [
                Column(
                  children: [
                    Text(
                      _costFormat.format(meterCosts.totalCosts),
                      overflow: TextOverflow.ellipsis,
                      style: _bodyStyle,
                    ),
                    Text(
                      "Gesamt",
                      style: _labelStyle,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      _costFormat.format(meterCosts.averageUsageMonth),
                      overflow: TextOverflow.ellipsis,
                      style: _bodyStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CustomIcons.empty_set,
                          size: _labelStyle.fontSize!,
                          color: _labelStyle.color!,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Monat",
                          style: _labelStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _tablePredictedTotalCosts() {
    return Column(
      children: [
        Text(
          'Geschätzter Verbrauch',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Table(
          children: [
            TableRow(children: [
              Column(
                children: [
                  ConvertMeterUnit().getUnitWidget(
                    count: meterCosts.averageUsage.toString(),
                    unit: meterCosts.meterUnit,
                    textStyle: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  Text(
                    "Gesamt Verbrauch",
                    style: _labelStyle,
                  ),
                ],
              ),
              Container(),
            ]),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Text(
                        _costFormat.format(meterCosts.totalCosts),
                        overflow: TextOverflow.ellipsis,
                        style: _bodyStyle,
                      ),
                      Text(
                        "Gesamt Kosten",
                        style: _labelStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Text(
                        _costFormat.format(meterCosts.averageUsageMonth),
                        overflow: TextOverflow.ellipsis,
                        style: _bodyStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CustomIcons.empty_set,
                            size: _labelStyle.fontSize!,
                            color: _labelStyle.color!,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Monat",
                            style: _labelStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _tableTotalPaid() {
    double diff = meterCosts.balance;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Rechnung',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  const Column(children: [
                    Text(
                      'Bezahlter Abschlag',
                    ),
                  ]),
                  Column(children: [
                    Text(
                      _costFormat.format(meterCosts.totalPaid),
                    ),
                    Text(
                      '${_costFormat.format(meterCosts.contract.costs.discount)} x ${meterCosts.sumOfMonths} Monate',
                      style: _labelStyle,
                    ),
                  ]),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text(
                          diff.isNegative
                              ? 'mögliche Nachzahlung'
                              : 'mögliche Erstattung',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text(
                          _costFormat.format(diff.abs()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _tableSelectedTimeRange() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Zeitraum',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  Column(children: [
                    Text(
                      _dateFormat.format(meterCosts.startDate!),
                    ),
                    Text(
                      'Von',
                      style: _labelStyle,
                    ),
                  ]),
                  Column(children: [
                    Text(
                      _dateFormat.format(meterCosts.endDate!),
                    ),
                    Text(
                      'Bis',
                      style: _labelStyle,
                    ),
                  ]),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
