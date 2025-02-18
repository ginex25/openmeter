import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/model/contract_dto.dart';
import 'package:openmeter/core/model/provider_dto.dart';
import 'package:openmeter/features/contract/provider/archived_contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/widget/provider_bottom_sheet.dart';
import 'package:openmeter/ui/widgets/tags/canceled_tag.dart';
import 'package:openmeter/ui/widgets/tags/should_cancel_tag.dart';
import 'package:openmeter/utils/meter_typ.dart';

class ProviderCard extends ConsumerStatefulWidget {
  final ProviderDto? provider;
  final ContractDto contract;

  const ProviderCard({super.key, this.provider, required this.contract});

  @override
  ConsumerState createState() => _ProviderCardState();
}

class _ProviderCardState extends ConsumerState<ProviderCard> {
  ProviderDto? currentProvider;

  bool hasCanceled = false;

  @override
  initState() {
    if (widget.provider != null) {
      currentProvider = widget.provider!;
    }
    super.initState();
  }

  _openBottomSheet() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProviderBottomSheet(
        createProvider: currentProvider != null ? false : true,
        contract: widget.contract,
      ),
    ).then(
      (value) {
        setState(() {
          if (value != -1) {
            currentProvider = value;
          }
        });
      },
    );
  }

  _selectCanceledDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: currentProvider!.canceledDate != null
          ? currentProvider!.canceledDate!
          : DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      locale: const Locale('de', ''),
    );

    if (date != null) {
      setState(() {
        currentProvider!.canceledDate = date;
        currentProvider!.canceled = true;
        currentProvider!.showShouldCanceled = false;
      });

      if (widget.contract.isArchived) {
        ref
            .read(archivedContractListProvider.notifier)
            .updateProvider(widget.contract, currentProvider!);
      } else {
        ref
            .read(contractListProvider.notifier)
            .updateProvider(widget.contract, currentProvider!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vertragsübersicht',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () => _openBottomSheet(),
                    icon: const Icon(
                      Icons.edit_note,
                      size: 30,
                    ),
                  ),
                ],
              ),
              if (currentProvider != null && currentProvider!.canceled!)
                const SizedBox(
                  height: 25,
                  child: CanceledTag(),
                ),
              if (currentProvider != null &&
                  currentProvider!.showShouldCanceled)
                const SizedBox(
                  height: 25,
                  child: ShouldCancelTag(),
                ),
              const SizedBox(
                height: 10,
              ),
              currentProvider == null
                  ? EmptyProvider(
                      contractMeterTyp: widget.contract.meterTyp,
                      onTextPressed: () {
                        _openBottomSheet();
                      },
                    )
                  : ProviderData(
                      currentProvider: currentProvider!,
                      selectCanceledDate: _selectCanceledDate,
                    ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderData extends StatelessWidget {
  final ProviderDto currentProvider;
  final VoidCallback selectCanceledDate;

  const ProviderData(
      {super.key,
      required this.currentProvider,
      required this.selectCanceledDate});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy');

    return Table(
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Anbieter',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SelectableText(
                currentProvider.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Nummer',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SelectableText(
                currentProvider.contractNumber,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Beginn',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                dateFormat.format(currentProvider.validFrom),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Ende',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                dateFormat.format(currentProvider.validUntil),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        if (currentProvider.renewal != null)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Verlängerung',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '${currentProvider.renewal} Monate',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        if (currentProvider.notice != null)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Kündigungsfrist',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '${currentProvider.notice} Monate',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Gekündigt am',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 25,
              child: TextButton(
                onPressed: selectCanceledDate,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  alignment: Alignment.centerLeft,
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.bodyMedium),
                  foregroundColor: WidgetStateProperty.all(
                    currentProvider.canceled ?? false
                        ? Theme.of(context).textTheme.titleLarge!.color
                        : null,
                  ),
                ),
                child: currentProvider.canceled ?? false
                    ? Text(dateFormat.format(currentProvider.canceledDate!))
                    : const Text('Datum wählen'),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class EmptyProvider extends StatelessWidget {
  final String contractMeterTyp;
  final VoidCallback? onTextPressed;

  const EmptyProvider(
      {super.key, required this.contractMeterTyp, this.onTextPressed});

  @override
  Widget build(BuildContext context) {
    final meterTyp =
        meterTyps.firstWhere((element) => element.meterTyp == contractMeterTyp);

    return Column(
      children: [
        Text(
          'Es wurde noch kein Vertrag für diesen ${meterTyp.providerTitle} angelegt.',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey,
              ),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: onTextPressed,
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all(
              Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
            ),
            foregroundColor: WidgetStateProperty.all(Colors.grey),
          ),
          child: const Text(
            'Drücke hier, um einen Vertrag zu erstellen',
          ),
        ),
      ],
    );
  }
}
