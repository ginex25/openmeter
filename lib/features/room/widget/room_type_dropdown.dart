import 'package:flutter/material.dart';
import 'package:openmeter/utils/room_typ.dart';

class RoomTypeDropdown extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String?> onChanged;

  const RoomTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        isExpanded: true,
        decoration: const InputDecoration(
          label: Text(
            'Zimmertyp',
          ),
          icon: Icon(Icons.bedroom_parent_outlined),
        ),
        items: roomTyps.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Row(
              children: [
                Text(e),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
