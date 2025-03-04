import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';

class RoomDropdown extends ConsumerStatefulWidget {
  final Function(RoomDto?) onRoomSelected;
  final String roomId;

  const RoomDropdown({
    super.key,
    required this.onRoomSelected,
    required this.roomId,
  });

  @override
  ConsumerState createState() => _RoomDropdownState();
}

class _RoomDropdownState extends ConsumerState<RoomDropdown> {
  final _roomList = [
    const DropdownMenuItem(
      value: "-1",
      child: Text('Keinem Zimmer zugeordnet'),
    ),
  ];

  final List<int> _viewedRoomIds = [];

  void _createRoomDropDown(List<RoomDto> rooms) {
    for (RoomDto room in rooms) {
      if (_viewedRoomIds.contains(room.id)) {
        continue;
      }

      _viewedRoomIds.add(room.id!);

      _roomList.add(DropdownMenuItem(
        value: room.uuid,
        child: Text('${room.typ}: ${room.name}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = ref.watch(roomListProvider);

    return roomProvider.when(
      data: (data) {
        final roomList = data.$1 + data.$2;

        if (roomList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                label: Text(
                  'Zimmer',
                ),
                // icon: Icon(Icons.bedroom_parent_outlined),
                icon: FaIcon(
                  FontAwesomeIcons.bed,
                  size: 16,
                ),
              ),
              value: '-1',
              items: [],
              onChanged: null,
            ),
          );
        }

        roomList.sort(
          (a, b) => a.name.compareTo(b.name),
        );

        _createRoomDropDown(roomList);

        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: DropdownButtonFormField(
            isExpanded: true,
            decoration: const InputDecoration(
              label: Text(
                'Zimmer',
              ),
              icon: FaIcon(
                FontAwesomeIcons.bed,
                size: 16,
              ),
            ),
            value: widget.roomId == "-2" ? "-1" : widget.roomId,
            items: _roomList,
            onChanged: (value) {
              RoomDto? selectedRoom;

              for (RoomDto room in roomList) {
                if (room.uuid == value) {
                  selectedRoom = room;
                  break;
                }
              }

              widget.onRoomSelected(selectedRoom);
            },
          ),
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const SizedBox(),
    );
  }
}
