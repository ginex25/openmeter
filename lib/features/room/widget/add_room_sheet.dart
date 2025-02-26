import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/room/widget/room_type_dropdown.dart';
import 'package:uuid/uuid.dart';

class AddRoomSheet extends ConsumerStatefulWidget {
  const AddRoomSheet({super.key});

  @override
  ConsumerState createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends ConsumerState<AddRoomSheet> {
  final uuid = const Uuid();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  String _roomTyp = 'Sonstiges';

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  _saveRoom() async {
    if (_formKey.currentState!.validate()) {
      if (_nameController.text.isEmpty) {
        _nameController.text = _roomTyp;
      }

      await ref
          .read(roomListProvider.notifier)
          .addRoom(_roomTyp, _nameController.text, uuid.v1())
          .then(
        (value) {
          if (mounted) {
            Navigator.of(context).pop();
          }

          _roomTyp = 'Sonstiges';
          _nameController.clear();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const Text(
                  'Neues Zimmer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoomTypeDropdown(
                  selectedType: _roomTyp,
                  onChanged: (value) {
                    _roomTyp = value.toString();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.abc), label: Text('Zimmername')),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: () => _saveRoom(),
                    label: const Text('Speichern'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
