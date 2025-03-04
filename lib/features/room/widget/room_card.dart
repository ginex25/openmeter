import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/meters/widgets/meter_circle_avatar.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/room/provider/selected_room_count_provider.dart';
import 'package:openmeter/features/room/view/details_room.dart';
import 'package:openmeter/utils/meter_typ.dart';

class RoomCard extends ConsumerStatefulWidget {
  final RoomDto room;

  const RoomCard(this.room, {super.key});

  @override
  ConsumerState createState() => _RoomCardState();
}

class _RoomCardState extends ConsumerState<RoomCard> {
  @override
  Widget build(BuildContext context) {
    final int selectedRoomsCount = ref.watch(selectedRoomCountProvider);
    final int selectedContracts = ref.watch(selectedContractCountProvider);

    final room = widget.room;

    return GestureDetector(
      onLongPress: () {
        if (selectedContracts == 0) {
          ref.read(roomListProvider.notifier).toggleState(room);
        }
      },
      onTap: () {
        if (selectedContracts > 0) {
          return;
        }

        if (selectedRoomsCount > 0) {
          ref.read(roomListProvider.notifier).toggleState(room);
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsRoom(room.id!),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        height: 170,
        child: Card(
          color: room.isSelected ? Theme.of(context).highlightColor : null,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          room.typ,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Zimmertyp',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          room.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Zimmername',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    '${room.meters.length} Zähler',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 8),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: room.meters.length,
                      itemBuilder: (context, index) {
                        final meter = room.meters[index];

                        final avatarData = meterTyps
                            .firstWhere(
                                (element) => element.meterTyp == meter.typ)
                            .avatar;

                        return MeterCircleAvatar(
                          color: avatarData.color,
                          icon: avatarData.icon,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 5);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
