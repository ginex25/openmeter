import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/model/sort_model.dart';
import 'package:openmeter/features/meters/provider/sort_provider.dart';

class SortIconButton extends ConsumerStatefulWidget {
  const SortIconButton({super.key});

  @override
  ConsumerState createState() => _SortIconButtonState();
}

class _SortIconButtonState extends ConsumerState<SortIconButton> {
  late SortModel sort;

  String _sortValue = 'room';
  String _orderValue = 'asc';

  void onSortChange(String? value, Function setState) {
    setState(() {
      _sortValue = value ?? 'room';
    });
  }

  void onOrderChange(String? value, Function setState) {
    setState(() {
      _orderValue = value ?? 'asc';
    });
  }

  void showButtonDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sortieren nach'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text('Raum'),
                  value: 'room',
                  groupValue: _sortValue,
                  onChanged: (value) => onSortChange(value, setState),
                ),
                RadioListTile(
                  title: const Text('Zähler'),
                  value: 'meter',
                  groupValue: _sortValue,
                  onChanged: (value) => onSortChange(value, setState),
                ),
                const Divider(thickness: 0.3),
                RadioListTile(
                  title: const Text('Aufsteigend'),
                  value: 'asc',
                  groupValue: _orderValue,
                  onChanged: (value) => onOrderChange(value, setState),
                ),
                RadioListTile(
                  title: const Text('Absteigend'),
                  value: 'desc',
                  groupValue: _orderValue,
                  onChanged: (value) => onOrderChange(value, setState),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              ref.read(sortProviderProvider.notifier).setSort(_sortValue);
              ref.read(sortProviderProvider.notifier).setOrder(_orderValue);
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Sortieren',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sort = ref.watch(sortProviderProvider);

    _sortValue = sort.sort;
    _orderValue = sort.order;

    return IconButton(
      onPressed: () {
        return showButtonDialog();
      },
      icon: const Icon(Icons.filter_list),
      tooltip: 'Sortieren',
    );
  }
}
