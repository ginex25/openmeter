import 'package:flutter/material.dart';

class NumberTextFields extends StatelessWidget {
  final String label;
  final String suffix;
  final TextEditingController controller;

  const NumberTextFields(
      {super.key,
      required this.label,
      required this.suffix,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bitte gib eine $label an!';
        }
        return null;
      },
      decoration: InputDecoration(
        label: Text(label),
        suffix: Text(suffix),
      ),
    );
  }
}
