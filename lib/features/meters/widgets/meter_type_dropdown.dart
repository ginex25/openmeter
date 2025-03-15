import 'package:flutter/material.dart';
import 'package:openmeter/core/model/meter_typ.dart';
import 'package:openmeter/features/meters/widgets/meter_circle_avatar.dart';
import 'package:openmeter/shared/constant/meter_typ.dart';

class MeterTypeDropdown extends StatelessWidget {
  final String defaultValue;
  final Function(String? value) onChanged;

  const MeterTypeDropdown(
      {super.key, required this.defaultValue, required this.onChanged});

  List<MeterTyp> _filterMeterTyps() {
    List<MeterTyp> result = [];

    for (MeterTyp element in meterTyps) {
      if (element.providerTitle.isNotEmpty) {
        result.add(element);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final List<MeterTyp> newMeterTyps = _filterMeterTyps();

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Bitte wähle einen Zählertyp!';
          }
          return null;
        },
        value: defaultValue,
        isExpanded: true,
        decoration: const InputDecoration(
          label: Text('Zählertyp'),
          icon: Icon(Icons.gas_meter_outlined),
        ),
        isDense: false,
        items: newMeterTyps.map((element) {
          final avatarData = element.avatar;
          return DropdownMenuItem(
            value: element.meterTyp,
            child: Row(
              children: [
                MeterCircleAvatar(
                  color: avatarData.color,
                  icon: avatarData.icon,
                  size: MediaQuery.of(context).size.width * 0.045,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(element.meterTyp),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
