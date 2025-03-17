import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/provider/reminder_provider.dart';
import 'package:openmeter/features/reminder/widgets/repeat_tile.dart';

import '../model/notifications_repeat_values.dart';
import 'month_tile.dart';
import 'time_picker_tile.dart';
import 'week_tile.dart';

class ActiveReminder extends ConsumerWidget {
  const ActiveReminder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReminderModel reminder = ref.watch(reminderProvider);

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 0.5,
        ),
        Text(
          'Wiederholung',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const RepeatTile(),
        if (reminder.repeatValues == RepeatValues.weekly) const WeekTile(),
        if (reminder.repeatValues == RepeatValues.monthly) const MonthTile(),
        const TimePickerTile(),
      ],
    );
  }
}
