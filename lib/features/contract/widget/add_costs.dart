import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/model/compare_costs.dart';
import 'package:openmeter/features/contract/model/contract_costs.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/provider/details_contract_provider.dart';
import 'package:openmeter/features/contract/widget/number_text_field.dart';
import 'package:openmeter/utils/convert_meter_unit.dart';

class AddCosts extends ConsumerStatefulWidget {
  final ContractDto contract;

  const AddCosts({super.key, required this.contract});

  @override
  ConsumerState createState() => _AddCostsState();
}

class _AddCostsState extends ConsumerState<AddCosts> {
  final _form = GlobalKey<FormState>();

  final TextEditingController _basicPrice = TextEditingController();
  final TextEditingController _energyPrice = TextEditingController();
  final TextEditingController _bonus = TextEditingController();
  final TextEditingController _usage = TextEditingController();

  final ConvertMeterUnit _convertMeterUnit = ConvertMeterUnit();
  bool _isUpdate = false;

  @override
  void initState() {
    _initController(widget.contract.compareCosts);

    super.initState();
  }

  @override
  void dispose() {
    _basicPrice.dispose();
    _energyPrice.dispose();
    _bonus.dispose();
    _usage.dispose();

    super.dispose();
  }

  _initController(CompareCosts? compareContract) {
    if (compareContract != null) {
      _isUpdate = true;

      final costs = compareContract.costs;
      _basicPrice.text = costs.basicPrice.toString();
      _energyPrice.text = costs.energyPrice.toString();
      _bonus.text = costs.bonus == null ? '' : costs.bonus.toString();
      _usage.text = compareContract.usage.toString();
    }
  }

  double _convertEnergyPrice() {
    if (_energyPrice.text.contains(',')) {
      return double.parse(_energyPrice.text.replaceAll(',', '.'));
    } else {
      return double.parse(_energyPrice.text);
    }
  }

  _handleOnSave() async {
    if (_form.currentState!.validate()) {
      int bonus = _bonus.text.isEmpty ? 0 : int.parse(_bonus.text);

      ContractCosts costs = ContractCosts(
          basicPrice: double.parse(_basicPrice.text),
          energyPrice: _convertEnergyPrice(),
          bonus: bonus,
          discount: 0.0);

      CompareCosts compareCosts = CompareCosts(
        costs: costs,
        usage: int.parse(_usage.text),
        parentId: widget.contract.id,
      );

      if (_isUpdate) {
        await ref
            .read(detailsContractProvider(widget.contract.id!).notifier)
            .updateCompareCost(compareCosts);
      } else {
        ref
            .read(detailsContractProvider(widget.contract.id!).notifier)
            .addCompareCosts(compareCosts);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          spacing: 15,
          children: [
            NumberTextFields(
                label: 'Grundpreis',
                suffix: 'in Euro/Jahr',
                controller: _basicPrice),
            NumberTextFields(
                label: 'Arbeitspreis',
                suffix: 'in Cent',
                controller: _energyPrice),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: _bonus,
              decoration: const InputDecoration(
                label: Text('Bonus'),
                suffix: Text('in Euro'),
                labelStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: _usage,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte gib einen Verbrauchswert an!';
                }

                return null;
              },
              decoration: InputDecoration(
                label: const Text('Verbrauch'),
                suffix: Text(
                    'in ${_convertMeterUnit.getUnitString(widget.contract.unit)}'),
                labelStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: _handleOnSave,
                label: const Text('Vergleichen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
