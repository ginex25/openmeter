import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/provider/reminder_provider.dart';

class WeekTile extends ConsumerStatefulWidget {
  const WeekTile({super.key});

  @override
  ConsumerState<WeekTile> createState() => _WeekTileState();
}

class _WeekTileState extends ConsumerState<WeekTile> {
  String _selectedWeek = 'Montag';

  final weekDays = [
    'Montag',
    'Dienstag',
    'Mittwoch',
    'Donnerstag',
    'Freitag',
    'Samstag',
    'Sonntag'
  ];

  _weekDaysDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: weekDays.map((e) {
                  return RadioListTile(
                    value: e,
                    groupValue: _selectedWeek,
                    title: Text(e),
                    onChanged: (value) {
                      ref
                          .read(reminderProvider.notifier)
                          .setWeekDay(weekDays.indexOf(e));

                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReminderModel reminder = ref.watch(reminderProvider);

    _selectedWeek = weekDays.elementAt(reminder.weekDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wochentag',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ListTile(
          title: Text(
            _selectedWeek,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: const Text('Wähle den Wochentag der Benachrichtigung.'),
          leading: const FaIcon(FontAwesomeIcons.calendarDay),
          onTap: () => _weekDaysDialog(),
        ),
      ],
    );
  }
}
