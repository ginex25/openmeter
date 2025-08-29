import 'package:flutter/material.dart';

class SelectedCountAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int count;
  final VoidCallback? onCancelButton;

  const SelectedCountAppBar({super.key, required this.count, required this.onCancelButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onCancelButton,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
