import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/provider/reminder_provider.dart';

class MonthTile extends ConsumerStatefulWidget {
  const MonthTile({super.key});

  @override
  ConsumerState<MonthTile> createState() => _MonthTileState();
}

class _MonthTileState extends ConsumerState<MonthTile> {
  int _selectedDay = 1;
  final _monthDays = List.generate(30, (index) => index + 1, growable: false);

  _monthDaysDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _monthDays.map((e) {
                    return RadioListTile(
                      value: e,
                      groupValue: _selectedDay,
                      title: Text('$e'),
                      onChanged: (value) {
                        ref
                            .read(reminderProvider.notifier)
                            .setMonthDay(value ?? 1);

                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
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

    _selectedDay = reminder.monthDay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tag im Monat',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ListTile(
          title: Text(
            '$_selectedDay',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: const Text('Wähle den Tag des Monats der Benachrichtigung'),
          leading: const FaIcon(FontAwesomeIcons.solidCalendarDays),
          onTap: () => _monthDaysDialog(),
        ),
      ],
    );
  }
}
