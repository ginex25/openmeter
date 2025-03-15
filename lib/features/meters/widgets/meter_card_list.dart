import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/meters/provider/sort_provider.dart';
import 'package:openmeter/shared/constant/custom_colors.dart';
import 'package:openmeter/shared/utils/convert_count.dart';

import 'meter_card.dart';

class MeterCardList extends ConsumerWidget {
  final List<MeterDto> meters;
  final Function(MeterDto meter) onLongPress;
  final Function(MeterDto meter) onDelete;
  final Function(MeterDto meter) onSidePanelAction;
  final String startPanelLabel;
  final IconData startPanelIcon;
  final Function(MeterDto meter) onCardTap;

  const MeterCardList({
    super.key,
    required this.meters,
    required this.onLongPress,
    required this.onDelete,
    required this.onSidePanelAction,
    this.startPanelLabel = 'Archivieren',
    this.startPanelIcon = Icons.archive,
    required this.onCardTap,
  });

  _groupBy(String sortBy, MeterDto meter) {
    dynamic sortedElement;

    switch (sortBy) {
      case 'room':
        sortedElement = meter.room ?? '';
        break;
      case 'meter':
        sortedElement = meter.typ;
        break;
      default:
        sortedElement = 'room';
    }

    return sortedElement;
  }

  GroupedListOrder _orderBy(String order) {
    if (order == 'asc') {
      return GroupedListOrder.ASC;
    } else if (order == 'desc') {
      return GroupedListOrder.DESC;
    } else {
      return GroupedListOrder.ASC;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedMetersCount = ref.watch(selectedMetersCountProvider);

    final sortProvider = ref.watch(sortProviderProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: GroupedListView(
        shrinkWrap: true,
        stickyHeaderBackgroundColor: Theme.of(context).canvasColor,
        floatingHeader: false,
        elements: meters,
        groupBy: (element) {
          return _groupBy(sortProvider.sort, element);
        },
        order: _orderBy(sortProvider.order),
        groupSeparatorBuilder: (element) => Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 2),
          child: Text(
            element,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        itemBuilder: (context, meter) {
          final DateTime? date;
          final String count;

          if (meter.lastEntry == null) {
            date = null;
            count = 'none';
          } else {
            date = meter.lastEntry!.date;

            count = ConvertCount.convertCount(meter.lastEntry!.count);
          }

          return GestureDetector(
            onLongPress: () => onLongPress(meter),
            child: selectedMetersCount > 0
                ? MeterCard(
                    meter: meter,
                    date: date,
                    count: count,
                    onTap: () {
                      onCardTap(meter);
                    },
                  )
                : _cardWithSlide(
                    meterItem: meter,
                    roomName: meter.room ?? '',
                    isSelected: meter.isSelected,
                    date: date,
                    count: count,
                    hasSelectedItems: selectedMetersCount > 0,
                  ),
          );
        },
      ),
    );
  }

  Widget _cardWithSlide(
      {required MeterDto meterItem,
      required DateTime? date,
      required String count,
      required bool isSelected,
      required bool hasSelectedItems,
      required String roomName}) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onDelete(meterItem);

              // databaseSettingsProvider.setHasUpdate(true);
            },
            icon: Icons.delete,
            label: 'Löschen',
            backgroundColor: CustomColors.red,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // databaseSettingsProvider.setHasUpdate(true);
              onSidePanelAction(meterItem);
            },
            icon: startPanelIcon,
            label: startPanelLabel,
            foregroundColor: Colors.white,
            backgroundColor: CustomColors.blue,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
      child: MeterCard(
        meter: meterItem,
        date: date,
        count: count,
        onTap: () {
          onCardTap(meterItem);
        },
      ),
    );
  }
}
