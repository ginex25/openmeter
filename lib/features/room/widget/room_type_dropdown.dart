import 'package:flutter/material.dart';
import 'package:openmeter/shared/constant/room_typ.dart';

class RoomTypeDropdown extends StatefulWidget {
  final String selectedType;
  final ValueChanged<String?> onChanged;

  const RoomTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  State<RoomTypeDropdown> createState() => _RoomTypeDropdownState();
}

class _RoomTypeDropdownState extends State<RoomTypeDropdown> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: DropdownButtonFormField<String>(
        value: widget.selectedType,
        focusNode: _focusNode,
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
        onChanged: (value) {
          _focusNode.unfocus();
          widget.onChanged(value);
        },
      ),
    );
  }
}
