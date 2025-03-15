import 'package:flutter/material.dart';
import 'package:openmeter/features/meters/widgets/meter_circle_avatar.dart';
import 'package:openmeter/features/room/model/meter_room_dto.dart';
import 'package:openmeter/features/tags/widget/horizontal_tags_list.dart';
import 'package:openmeter/shared/constant/meter_typ.dart';

class MeterCompactTile extends StatelessWidget {
  final MeterRoomDto data;
  final bool isSelected;
  final Function() onSelect;

  const MeterCompactTile(
      {super.key,
      required this.data,
      required this.onSelect,
      required this.isSelected});

  Widget _getSelectedIcon(BuildContext context) {
    if (data.isInCurrentRoom) {
      return const Icon(
        Icons.check_circle,
        color: Colors.grey,
      );
    }

    if (isSelected) {
      return Icon(
        Icons.check_circle,
        color: Theme.of(context).primaryColor,
      );
    }

    return const Icon(Icons.radio_button_unchecked);
  }

  @override
  Widget build(BuildContext context) {
    final avatarData = meterTyps
        .firstWhere((element) => element.meterTyp == data.meter.typ)
        .avatar;

    final roomData = data.room;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        onTap: data.isInCurrentRoom ? null : onSelect,
        leading: MeterCircleAvatar(
          color: avatarData.color,
          icon: avatarData.icon,
        ),
        trailing: _getSelectedIcon(context),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      data.meter.number,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Zählernummer',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                if (data.meter.note.isNotEmpty)
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Text(
                          data.meter.note,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Notiz',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            HorizontalTagsList(
              meterId: data.meter.id!,
              tags: [],
            ),
            if (data.isInARoom)
              Text(
                'Bereits im ${roomData?.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
