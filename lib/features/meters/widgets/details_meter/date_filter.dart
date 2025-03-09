import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/features/meters/model/entry_filter_model.dart';
import 'package:openmeter/features/meters/provider/entry_filter_provider.dart';
import 'package:openmeter/utils/datetime_formats.dart';

class DateFilter extends ConsumerStatefulWidget {
  const DateFilter({super.key});

  @override
  ConsumerState createState() => _DateFilterState();
}

class _DateFilterState extends ConsumerState<DateFilter> {
  bool _showStartDateHint = false;
  bool _showEndDateHint = false;

  bool _startDateFilterState = false;
  bool _endDateFilterState = false;

  DateTime? _startDate;
  DateTime? _endDate;

  Future<DateTime?> _showDatePicker(DateTime? initialDate) async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 20),
      lastDate: now,
      initialDate: initialDate ?? now,
    );

    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(entryFilterProvider);

    _startDateFilterState = filter.filters.contains(EntryFilters.dateBegin);
    _endDateFilterState = filter.filters.contains(EntryFilters.dateEnd);

    _startDate = filter.startDate;
    _endDate = filter.endDate;

    final BoxDecoration hintBoxDecoration = BoxDecoration(
      border: Border.all(
        color: Theme.of(context).colorScheme.error,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(16),
    );

    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: _showStartDateHint ? hintBoxDecoration : null,
              width: MediaQuery.sizeOf(context).width * 0.7,
              child: ListTile(
                onTap: () async {
                  final date = await _showDatePicker(filter.startDate);

                  setState(
                    () {
                      _showStartDateHint = false;

                      _startDate = date;

                      if (date == null) {
                        _startDateFilterState = false;
                      }
                    },
                  );

                  ref.read(entryFilterProvider.notifier).updateStartDate(date);
                },
                title:
                    Text('Von', style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  _startDate == null
                      ? 'Datum auswählen'
                      : DateFormat(DateTimeFormats.germanDate)
                          .format(_startDate!),
                ),
                subtitleTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                        color: _showStartDateHint
                            ? Theme.of(context).colorScheme.error
                            : null),
              ),
            ),
            const SizedBox(
              height: 50,
              child: VerticalDivider(),
            ),
            Switch(
              value: _startDateFilterState,
              onChanged: (value) {
                if (_startDate == null) {
                  setState(() => _showStartDateHint = true);
                  return;
                }

                if (value) {
                  ref
                      .read(entryFilterProvider.notifier)
                      .addFilter(EntryFilters.dateBegin);
                } else {
                  ref
                      .read(entryFilterProvider.notifier)
                      .removeSpecificFilter(EntryFilters.dateBegin);
                }
              },
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
              decoration: _showEndDateHint ? hintBoxDecoration : null,
              width: MediaQuery.sizeOf(context).width * 0.7,
              child: ListTile(
                onTap: () async {
                  final date = await _showDatePicker(filter.startDate);

                  setState(
                    () {
                      _showEndDateHint = false;

                      _endDate = date;

                      if (date == null) {
                        _endDateFilterState = false;
                      }
                    },
                  );

                  ref.read(entryFilterProvider.notifier).updateEndDate(date);
                },
                title:
                    Text('Bis', style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  _endDate == null
                      ? 'Datum auswählen'
                      : DateFormat(DateTimeFormats.germanDate)
                          .format(_endDate!),
                ),
                subtitleTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                        color: _showEndDateHint
                            ? Theme.of(context).colorScheme.error
                            : null),
              ),
            ),
            const SizedBox(
              height: 50,
              child: VerticalDivider(),
            ),
            Switch(
              value: _endDateFilterState,
              onChanged: (value) {
                if (_endDate == null) {
                  setState(() => _showEndDateHint = true);
                  return;
                }

                if (value) {
                  ref
                      .read(entryFilterProvider.notifier)
                      .addFilter(EntryFilters.dateEnd);
                } else {
                  ref
                      .read(entryFilterProvider.notifier)
                      .removeSpecificFilter(EntryFilters.dateEnd);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
