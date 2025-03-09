import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/model/entry_filter_model.dart';
import 'package:openmeter/features/meters/provider/entry_filter_provider.dart';
import 'package:openmeter/features/meters/widgets/details_meter/date_filter.dart';

class EntryFilterButton extends StatelessWidget {
  const EntryFilterButton({super.key});

  _openBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.sizeOf(context).height * 0.47,
            width: MediaQuery.sizeOf(context).width,
            child: const EntryFilterSheetContent(),
          ),
        );
      },
    );
    // .then((value) {
    //   _showStartDateHint = false;
    //   _showEndDateHint = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _openBottomSheet(context),
      icon: const Icon(Icons.filter_list),
      tooltip: 'Einträge filtern',
    );
  }
}

class EntryFilterSheetContent extends ConsumerStatefulWidget {
  const EntryFilterSheetContent({super.key});

  @override
  ConsumerState createState() => _EntryFilterSheetContentState();
}

class _EntryFilterSheetContentState
    extends ConsumerState<EntryFilterSheetContent> {
  @override
  Widget build(BuildContext context) {
    final EntryFilterModel filter = ref.watch(entryFilterProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Einträge filtern',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            IconButton(
              onPressed: () {
                ref.read(entryFilterProvider.notifier).resetFilter();
              },
              icon: const Icon(Icons.replay),
              tooltip: 'Filter zurücksetzen',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton(
            segments: const [
              ButtonSegment(
                value: EntryFilters.note,
                label: Text('Notiz'),
                tooltip: 'Filtern nach Einträgen mit einer Notiz',
              ),
              ButtonSegment(
                value: EntryFilters.transmitted,
                label: Text('Übermittelt'),
                tooltip: 'Filtern nach übermittelt Einträgen',
              ),
            ],
            emptySelectionAllowed: true,
            multiSelectionEnabled: true,
            showSelectedIcon: false,
            selected: filter.filters,
            onSelectionChanged: (newSelected) {
              ref.read(entryFilterProvider.notifier).updateFilters(newSelected);
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton(
            segments: const [
              ButtonSegment(
                value: EntryFilters.photo,
                label: Text('Bilder'),
                tooltip: 'Filtern nach Einträgen mit einem Bild',
              ),
              ButtonSegment(
                value: EntryFilters.reset,
                label: Text('Zurückgesetzt'),
                tooltip: 'Filtern nach Einträgen die zurückgesetzt worden',
              ),
            ],
            emptySelectionAllowed: true,
            multiSelectionEnabled: true,
            showSelectedIcon: false,
            selected: filter.filters,
            onSelectionChanged: (newSelected) {
              ref.read(entryFilterProvider.notifier).updateFilters(newSelected);
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        DateFilter(),
      ],
    );
  }
}
