import 'package:flutter/material.dart';

class ReadingReminderTile extends StatelessWidget {
  const ReadingReminderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Ableseerinnerung',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      leading: const Icon(Icons.notifications),
      onTap: () {
        Navigator.of(context).pushNamed('reminder');
      },
    );
  }
}
