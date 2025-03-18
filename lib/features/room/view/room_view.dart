import 'package:flutter/material.dart';
import 'package:openmeter/features/room/widget/add_room_sheet.dart';
import 'package:openmeter/features/room/widget/room_grid.dart';

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          message: 'Raum erstellen',
          child: ListTile(
            title: Text(
              'Meine Zimmer',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            trailing: const Icon(Icons.add),
            onTap: () async {
              return await showModalBottomSheet(
                backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                isScrollControlled: true,
                context: context,
                builder: (context) => AddRoomSheet(),
              );
            },
          ),
        ),
        const RoomGrid(),
      ],
    );
  }
}
