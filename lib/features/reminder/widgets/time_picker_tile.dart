import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/provider/reminder_provider.dart';
import 'package:openmeter/utils/datetime_formats.dart';

class TimePickerTile extends ConsumerStatefulWidget {
  const TimePickerTile({super.key});

  @override
  ConsumerState<TimePickerTile> createState() => _TimePickerTileState();
}

class _TimePickerTileState extends ConsumerState<TimePickerTile> {
  String _lableTime = '18:00';

  DateTime _selectedTime = DateTime.now();

  final DateFormat _timeFormat = DateFormat(DateTimeFormats.timeShort);

  final DateTime _dateTimeNow = DateTime.now();

  _timePicker() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        final Widget mediaQueryWrapper = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
        return Localizations.override(
          context: context,
          locale: const Locale('de', ''),
          child: mediaQueryWrapper,
        );
      },
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }

      ref
          .read(reminderProvider.notifier)
          .setMinuteAndHour(pickedTime.minute, pickedTime.hour);
    });
  }

  _loadFromPrefs(ReminderModel reminder) {
    _selectedTime = DateTime(
      _dateTimeNow.year,
      _dateTimeNow.month,
      _dateTimeNow.day,
      reminder.hour,
      reminder.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReminderModel reminder = ref.watch(reminderProvider);

    _loadFromPrefs(reminder);

    _lableTime = _timeFormat.format(_selectedTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Uhrzeit',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ListTile(
          title: Text(
            _lableTime,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: const Text('Wähle die Uhrzeit der Benachrichtigung.'),
          leading: const FaIcon(FontAwesomeIcons.clock),
          onTap: () => _timePicker(),
        ),
      ],
    );
  }
}
