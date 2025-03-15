import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/provider/database_settings_provider.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/model/provider_dto.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/delete_provider_state.dart';
import 'package:openmeter/features/contract/provider/details_contract_provider.dart';
import 'package:openmeter/features/contract/widget/add_provider.dart';
import 'package:openmeter/features/contract/widget/number_text_field.dart';
import 'package:openmeter/features/meters/widgets/meter_type_dropdown.dart';
import 'package:openmeter/shared/constant/meter_typ.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';
import 'package:provider/provider.dart' as p;

class AddContract extends ConsumerStatefulWidget {
  final ContractDto? contract;
  final bool fromDetails;

  const AddContract({this.contract, super.key, this.fromDetails = false});

  @override
  ConsumerState createState() => _AddContractState();
}

class _AddContractState extends ConsumerState<AddContract> {
  final _formKey = GlobalKey<FormState>();
  final _expansionKey = GlobalKey();

  final TextEditingController _basicPrice = TextEditingController();
  final TextEditingController _energyPrice = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _bonus = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  final ConvertMeterUnit convertMeterUnit = ConvertMeterUnit();

  String _meterTyp = 'Stromzähler';
  bool _providerExpand = false;

  bool _isUpdate = false;
  String _pageName = 'Neuer Vertrag';

  ContractDto? _contractDto;
  ProviderDto? _providerDto;

  bool _deleteProvider = false;

  @override
  void initState() {
    _setController();
    super.initState();
  }

  @override
  void dispose() {
    _energyPrice.dispose();
    _basicPrice.dispose();
    _discount.dispose();
    _bonus.dispose();
    _note.dispose();
    _unitController.dispose();

    super.dispose();
  }

  void _setController() {
    _contractDto = widget.contract;
    _providerDto = _contractDto?.provider;

    final meterTyp =
        meterTyps.firstWhere((element) => element.meterTyp == _meterTyp);

    if (_contractDto == null) {
      _unitController.text = meterTyp.unit;
      return;
    }

    final String local = Platform.localeName;
    final formatPattern =
        NumberFormat.decimalPatternDigits(locale: local, decimalDigits: 2);

    _pageName = meterTyp.providerTitle;
    _isUpdate = true;
    _meterTyp = _contractDto!.meterTyp;
    _basicPrice.text = formatPattern.format(_contractDto!.costs.basicPrice);
    _energyPrice.text = formatPattern.format(_contractDto!.costs.energyPrice);
    _discount.text = formatPattern.format(_contractDto!.costs.discount);
    _bonus.text = _contractDto!.costs.bonus.toString();
    _note.text = _contractDto!.note!;
    _unitController.text = _contractDto!.unit;
  }

  int _convertBonus() {
    if (_bonus.text.isEmpty) {
      return 0;
    } else {
      return int.parse(_bonus.text);
    }
  }

  _convertDouble(String text) {
    String newText = text.replaceAll('.', '');

    return double.parse(newText.replaceAll(',', '.'));
  }

  double _convertEnergyPrice(String energyPrice) {
    if (energyPrice.contains(',')) {
      return double.parse(energyPrice.replaceAll(',', '.'));
    } else {
      return double.parse(energyPrice);
    }
  }

  Future<void> _createEntry() async {
    int bonus = _convertBonus();

    final contract = ContractCompanion(
      meterTyp: drift.Value(_meterTyp),
      provider: drift.Value(null),
      basicPrice: drift.Value(_convertDouble(_basicPrice.text)),
      energyPrice: drift.Value(_convertEnergyPrice(_energyPrice.text)),
      discount: drift.Value(_convertDouble(_discount.text)),
      bonus: drift.Value(bonus),
      note: drift.Value(_note.text),
      isArchived: drift.Value(_contractDto?.isArchived ?? false),
      unit: drift.Value(_unitController.text),
    );

    await ref
        .read(contractListProvider.notifier)
        .createContract(contract, _providerDto)
        .then(
      (value) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future _updateEntry() async {
    int bonus = _convertBonus();

    final contract = ContractData(
      id: _contractDto!.id!,
      meterTyp: _meterTyp,
      provider: _providerDto?.id,
      basicPrice: _convertDouble(_basicPrice.text),
      energyPrice: _convertEnergyPrice(_energyPrice.text),
      discount: _convertDouble(_discount.text),
      bonus: bonus,
      note: _note.text,
      isArchived: _contractDto!.isArchived,
      unit: _unitController.text,
    );

    await ref
        .read(contractListProvider.notifier)
        .updateContract(
            contract, _deleteProvider ? _contractDto?.provider : _providerDto)
        .then((value) {
      if (widget.fromDetails) {
        ref
            .read(detailsContractProvider(value.id!).notifier)
            .updateContract(value);
      }

      if (mounted) {
        Navigator.of(context).pop(value);
      }
    });
  }

  Future _handleOnSave() async {
    if (_formKey.currentState!.validate()) {
      if (_isUpdate) {
        await _updateEntry();
      } else {
        await _createEntry();
      }

      if (mounted) {
        p.Provider.of<DatabaseSettingsProvider>(context, listen: false)
            .setHasUpdate(true);
      }
    }
  }

  _getProvider(ProviderDto? provider) {
    _providerDto = provider;

    _handleOnSave();
  }

  void _scrollToContent(GlobalKey expansionKey) {
    final keyContext = expansionKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        if (keyContext.mounted) {
          Scrollable.ensureVisible(keyContext,
              duration: const Duration(milliseconds: 200));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _deleteProvider = ref.watch(deleteProviderStateProvider);

    if (_deleteProvider) {
      _providerDto = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageName),
      ),
      floatingActionButton: _providerExpand
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                _handleOnSave();
              },
              label: const Text('Speichern'),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 15,
              children: [
                MeterTypeDropdown(
                  defaultValue: _meterTyp,
                  onChanged: (value) {
                    setState(() {
                      _meterTyp = value ?? 'Stromzähler';
                    });
                  },
                ),
                UnitField(
                  convertMeterUnit: convertMeterUnit,
                  controller: _unitController,
                  onChanged: (String value) {
                    setState(() {});
                  },
                ),
                NumberTextFields(
                  label: 'Grundpreis',
                  suffix: 'in Euro',
                  controller: _basicPrice,
                ),
                NumberTextFields(
                  label: 'Arbeitspreis',
                  suffix: 'in Cent',
                  controller: _energyPrice,
                ),
                NumberTextFields(
                  label: 'Abschlag',
                  suffix: 'in Euro',
                  controller: _discount,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: _bonus,
                  decoration: const InputDecoration(
                    label: Text('Bonus'),
                    suffix: Text('in Euro'),
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _note,
                  decoration: const InputDecoration(
                    label: Text('Notiz'),
                  ),
                ),
                // _provider(),
                AddProviderTile(
                  providerExpand: _providerExpand,
                  onExpansionChanged: (value) {
                    if (value) {
                      _scrollToContent(_expansionKey);
                    }
                    setState(() {
                      _providerExpand = !_providerExpand;
                    });
                  },
                  expansionKey: _expansionKey,
                  children: [
                    AddProvider(
                      showCanceledButton: _providerDto != null,
                      createProvider: _isUpdate,
                      onSave: _getProvider,
                      textSize: 18,
                      provider: _providerDto,
                    ),
                  ],
                ),
                if (_providerExpand)
                  const SizedBox(
                    height: 70,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddProviderTile extends StatelessWidget {
  final bool providerExpand;
  final Function(bool value) onExpansionChanged;
  final Key expansionKey;
  final List<Widget> children;

  const AddProviderTile(
      {super.key,
      required this.providerExpand,
      required this.onExpansionChanged,
      required this.expansionKey,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Vertragsdetails',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: providerExpand
              ? Theme.of(context).primaryColor
              : Theme.of(context).hintColor,
        ),
      ),
      key: expansionKey,
      initiallyExpanded: providerExpand,
      tilePadding: const EdgeInsets.all(0),
      onExpansionChanged: onExpansionChanged,
      children: children,
    );
  }
}

class UnitField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) onChanged;
  final ConvertMeterUnit convertMeterUnit;

  const UnitField(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.convertMeterUnit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                icon: FaIcon(
                  FontAwesomeIcons.ruler,
                  size: 16,
                ),
                label: Text('Einheit'),
                hintText: 'm^3 entspricht m\u00B3'),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte geben Sie eine Einheit an!';
              }
              return null;
            },
            onChanged: onChanged,
          ),
        ),
        Column(
          children: [
            const Text(
              'Vorschau',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            convertMeterUnit.getUnitWidget(
              count: '',
              unit: controller.text,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
