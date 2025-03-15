import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/model/meter_typ.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/model/provider_dto.dart';
import 'package:openmeter/features/meters/widgets/meter_circle_avatar.dart';
import 'package:openmeter/features/tags/widget/tag_chip.dart';
import 'package:openmeter/shared/constant/meter_typ.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

class ContractCard extends ConsumerStatefulWidget {
  final ContractDto contractDto;

  const ContractCard({
    super.key,
    required this.contractDto,
  });

  @override
  ConsumerState createState() => _ContractCardState();
}

class _ContractCardState extends ConsumerState<ContractCard> {
  final ConvertMeterUnit _convertMeterUnit = ConvertMeterUnit();

  @override
  Widget build(BuildContext context) {
    // final themeProvider = p.Provider.of<ThemeChanger>(context);

    // bool isLargeText =
    //     themeProvider.getFontSizeValue == FontSizeValue.large ? true : false;

    final ContractDto contract = widget.contractDto;
    final ProviderDto? providerDto = contract.provider;

    bool isCanceled = providerDto?.canceled ?? false;

    final String local = Platform.localeName;
    final formatSimpleCurrency = NumberFormat.simpleCurrency(locale: local);

    final formatDecimal =
        NumberFormat.decimalPatternDigits(locale: local, decimalDigits: 2);

    final meterTyp = meterTyps.firstWhere(
        (element) => element.meterTyp == widget.contractDto.meterTyp);

    final CustomAvatar avatarData = meterTyp.avatar;

    return SizedBox(
      height: 180, //isLargeText ? 200 : 180,
      child: Card(
        color: contract.isSelected ? Theme.of(context).highlightColor : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  MeterCircleAvatar(
                    color: avatarData.color,
                    icon: avatarData.icon,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    meterTyp.providerTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  if (isCanceled)
                    const SizedBox(
                      height: 25,
                      child: CanceledTag(),
                    ),
                  if (contract.provider != null &&
                      contract.provider!.showShouldCanceled)
                    const SizedBox(
                      height: 25,
                      child: ShouldCancelTag(),
                    ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        formatSimpleCurrency.format(contract.costs.basicPrice),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Grundpreis',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${formatDecimal.format(contract.costs.energyPrice)} Cent/${_convertMeterUnit.getUnitString(contract.unit)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Arbeitspreis',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        formatSimpleCurrency.format(contract.costs.discount),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Abschlag',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
              if (contract.provider != null)
                ProviderInformation(provider: contract.provider!),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderInformation extends StatelessWidget {
  final ProviderDto provider;

  const ProviderInformation({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  provider.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Anbieter',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  provider.contractNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Vertragsnummer',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
