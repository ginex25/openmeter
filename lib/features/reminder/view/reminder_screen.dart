import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/provider/reminder_provider.dart';
import 'package:openmeter/features/reminder/widgets/active_reminder.dart';

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    ReminderModel reminder = ref.watch(reminderProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ableseerinnerung'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!reminder.isActive)
                Center(
                  child: Image.asset(
                    'assets/icons/notifications_disable.png',
                    width: 200,
                  ),
                ),
              if (reminder.isActive)
                Center(
                  child: Image.asset(
                    'assets/icons/notifications_enable.png',
                    width: 200,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              SwitchListTile(
                title: reminder.isActive
                    ? Text(
                        'An',
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                    : Text(
                        'Aus',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                subtitle: reminder.isActive
                    ? null
                    : const Text(
                        'Richte eine Ableseerinnerung ein, um Benachrichtigungen zu erhalten.'),
                contentPadding: const EdgeInsets.all(0),
                value: reminder.isActive,
                onChanged: (value) async {
                  final success = await ref
                      .read(reminderProvider.notifier)
                      .setActiveState(value);

                  if (!success && context.mounted) {
                    final snackBar = SnackBar(
                      content: Text(
                          'Benachrichtigungsberechtigung wurde nicht erteilt.'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              if (reminder.isActive) const ActiveReminder(),
            ],
          ),
        ),
      ),
    );
  }
}
