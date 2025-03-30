import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/reminder/model/remind_later.dart';
import 'package:openmeter/features/reminder/provider/remind_later_provider.dart';

class RemindLater extends ConsumerStatefulWidget {
  const RemindLater({super.key});

  @override
  ConsumerState createState() => _RemindLaterState();
}

class _RemindLaterState extends ConsumerState<RemindLater> {
  int _time = 1;
  bool _firstOpen = true;

  @override
  void dispose() {
    super.dispose();

    _firstOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    final remindLater = ref.watch(remindLaterProvider);

    if (_firstOpen) {
      _firstOpen = false;
      _time = remindLater.time;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Später erinnern',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Hinweis'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Legen Sie fest, wann Sie später an eine Benachrichtigung erinnert werden möchten. '),
                          Text(
                              'Wenn Sie eine Benachrichtigung erhalten, können Sie den Knopf "Später erinnern" drücken, '
                              'um die Erinnerung zum eingestellten Zeitpunkt erneut zu erhalten.'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton(
            segments: [
              ButtonSegment(
                value: RemindLaterType.day,
                label: Text('Tag'),
              ),
              ButtonSegment(
                value: RemindLaterType.hour,
                label: Text('Stunde'),
              ),
              ButtonSegment(
                value: RemindLaterType.minute,
                label: Text('Minute'),
              ),
            ],
            selected: {remindLater.type},
            emptySelectionAllowed: false,
            multiSelectionEnabled: false,
            onSelectionChanged: (type) {
              ref.read(remindLaterProvider.notifier).saveRemindLater(
                  remindLater.copyWith(type: type.first, time: 1));
              _time = 1;
            },
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: Slider(
                value: _time.toDouble(),
                min: 1,
                max: remindLater.type.max.toDouble(),
                allowedInteraction: SliderInteraction.slideOnly,
                label: _time.toString(),
                onChanged: (value) {
                  setState(() {
                    _time = value.toInt();
                  });
                },
                onChangeEnd: (value) {
                  ref.read(remindLaterProvider.notifier).saveRemindLater(
                      remindLater.copyWith(time: value.toInt()));
                },
              ),
            ),
            Text(_time.toString()),
          ],
        ),
      ],
    );
  }
}
