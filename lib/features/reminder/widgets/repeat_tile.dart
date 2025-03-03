import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openmeter/core/enums/notifications_repeat_values.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/provider/reminder_provider.dart';

class RepeatTile extends ConsumerStatefulWidget {
  const RepeatTile({super.key});

  @override
  ConsumerState createState() => _RepeatTileState();
}

class _RepeatTileState extends ConsumerState<RepeatTile> {
  String _getRepeatTyp(RepeatValues selectedRepeat) {
    switch (selectedRepeat) {
      case RepeatValues.daily:
        return 'Täglich';
      case RepeatValues.weekly:
        return 'Wöchentlich';
      default:
        return 'Monatlich';
    }
  }

  void onSelected(RepeatValues? value) {
    ref
        .read(reminderProvider.notifier)
        .setRepeatValue(value ?? RepeatValues.daily);

    Navigator.of(context).pop();
  }

  Future showRepeatDialog(BuildContext context, ReminderModel reminder) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    value: RepeatValues.daily,
                    groupValue: reminder.repeatValues,
                    title: const Text('Täglich'),
                    onChanged: onSelected,
                  ),
                  RadioListTile(
                    value: RepeatValues.weekly,
                    groupValue: reminder.repeatValues,
                    title: const Text('Wöchentlich'),
                    onChanged: onSelected,
                  ),
                  RadioListTile(
                    value: RepeatValues.monthly,
                    groupValue: reminder.repeatValues,
                    title: const Text('Monatlich'),
                    onChanged: onSelected,
                  ),
                ],
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

    String lableRepeatTyp = _getRepeatTyp(reminder.repeatValues);

    return ListTile(
      title: Text(
        lableRepeatTyp,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: const Text('Wähle zwischen täglich, wöchentlich und monatlich'),
      leading: const FaIcon(FontAwesomeIcons.rotate),
      onTap: () => showRepeatDialog(context, reminder),
    );
  }
}
