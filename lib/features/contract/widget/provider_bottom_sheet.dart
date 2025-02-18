import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/model/contract_dto.dart';
import 'package:openmeter/core/model/provider_dto.dart';
import 'package:openmeter/features/contract/provider/archived_contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';

import 'add_provider.dart';

class ProviderBottomSheet extends ConsumerStatefulWidget {
  final bool createProvider;
  final ContractDto contract;

  const ProviderBottomSheet(
      {super.key, required this.createProvider, required this.contract});

  @override
  ConsumerState createState() => _ProviderBottomSheetState();
}

class _ProviderBottomSheetState extends ConsumerState<ProviderBottomSheet> {
  ProviderDto? currentProvider;

  @override
  void initState() {
    currentProvider = widget.contract.provider;

    super.initState();
  }

  Widget _makeDismissible({required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(-1),
      child: GestureDetector(
        child: child,
      ),
    );
  }

  handleOnSave(ProviderDto? provider) {
    if (provider == null) {
      return;
    }

    if (widget.createProvider) {
      if (widget.contract.isArchived) {
        ref
            .read(archivedContractListProvider.notifier)
            .addProvider(widget.contract, provider);
      } else {
        ref
            .read(contractListProvider.notifier)
            .addProvider(widget.contract, provider);
      }
    } else {
      if (widget.contract.isArchived) {
        ref
            .read(archivedContractListProvider.notifier)
            .updateProvider(widget.contract, provider);
      } else {
        ref
            .read(contractListProvider.notifier)
            .updateProvider(widget.contract, provider);
      }
    }

    Navigator.of(context).pop(provider);
  }

  Widget _addProvider() {
    final headlineText = currentProvider != null
        ? 'Vertragsdetails ändern'
        : 'Vertragsdetails erstellen';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headlineText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: AddProvider(
              showCanceledButton: false,
              provider: currentProvider,
              textSize: 16,
              onSave: handleOnSave,
              createProvider: widget.createProvider,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: widget.createProvider ? 0.8 : 0.25,
        minChildSize: 0.2,
        maxChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                spacing: 15,
                children: [
                  Container(
                    height: 5,
                    width: 30,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                  SheetButtons(
                    removeCanceledDateCallback: () async {
                      if ((currentProvider?.canceled ?? false) == false) {
                        return;
                      }

                      ProviderDto? newProvider;

                      if (widget.contract.isArchived) {
                        newProvider = await ref
                            .read(archivedContractListProvider.notifier)
                            .removeCanceledState(
                                widget.contract, currentProvider!);
                      } else {
                        newProvider = await ref
                            .read(contractListProvider.notifier)
                            .providerRemoveCanceledState(
                                widget.contract, currentProvider!);
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop(newProvider);
                      }
                    },
                    removeDetailsCallback: () async {
                      if (currentProvider == null) {
                        return;
                      }

                      ProviderDto? newProvider;

                      if (widget.contract.isArchived) {
                        newProvider = await ref
                            .read(archivedContractListProvider.notifier)
                            .deleteProvider(widget.contract, currentProvider!);
                      } else {
                        newProvider = await ref
                            .read(contractListProvider.notifier)
                            .deleteProvider(widget.contract, currentProvider!);
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop(newProvider);
                      }
                    },
                  ),
                  const Divider(),
                  _addProvider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SheetButtons extends StatelessWidget {
  final VoidCallback? removeCanceledDateCallback;
  final VoidCallback? removeDetailsCallback;

  const SheetButtons(
      {super.key,
      required this.removeCanceledDateCallback,
      required this.removeDetailsCallback});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: FilledButton.tonal(
              onPressed: removeCanceledDateCallback,
              child: const Text(
                'Kündigung entfernen',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: FilledButton.tonal(
              onPressed: removeDetailsCallback,
              child: const Text(
                'Details entfernen',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
