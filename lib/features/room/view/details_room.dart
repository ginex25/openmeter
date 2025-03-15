import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/meters/widgets/meter_card.dart';
import 'package:openmeter/features/room/provider/details_room_provider.dart';
import 'package:openmeter/features/room/provider/details_room_selected_meter.dart';
import 'package:openmeter/features/room/widget/room_type_dropdown.dart';
import 'package:openmeter/shared/constant/custom_colors.dart';

import 'add_meter_to_room.dart';

class DetailsRoom extends ConsumerStatefulWidget {
  final int roomId;

  const DetailsRoom(this.roomId, {super.key});

  @override
  ConsumerState createState() => _DetailsRoomState();
}

class _DetailsRoomState extends ConsumerState<DetailsRoom> {
  final _formKey = GlobalKey<FormState>();

  bool _update = false;

  late RoomDto room;

  @override
  Widget build(BuildContext context) {
    final detailsProvider = ref.watch(detailsRoomProvider(widget.roomId));

    final int selectedMetersCount = ref.watch(detailsRoomSelectedMeterProvider);

    return detailsProvider.when(
      data: (data) {
        room = data.room;
        final meters = data.meters;

        return Scaffold(
          appBar: selectedMetersCount > 0
              ? _selectedAppBar(selectedMetersCount)
              : _nonSelectedAppBar(),
          body: PopScope(
            onPopInvokedWithResult: (bool didPop, _) async {
              if (selectedMetersCount > 0) {
                ref
                    .read(detailsRoomProvider(room.id!).notifier)
                    .removeSelectedMetersState();
              }
            },
            canPop: selectedMetersCount == 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoomDetails(
                        room: room,
                        update: _update,
                        onSelectedRoomType: (type) {
                          setState(() {
                            room.typ = type ?? room.typ;
                          });
                        },
                        onRoomNameChange: (name) {
                          setState(() {
                            room.name = name;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        '${room.meters.length} Zähler',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: Text(
                          'Neue Zähler zuordnen',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        dense: true,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddMeterToRoom(room),
                          ));
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: meters.length,
                        itemBuilder: (context, index) {
                          final meter = meters[index];

                          final String count =
                              meter.lastEntry?.count.toString() ?? 'none';

                          return GestureDetector(
                            onLongPress: () {
                              ref
                                  .read(detailsRoomProvider(room.id!).notifier)
                                  .toggleSelectMeterState(meter);
                            },
                            child: selectedMetersCount > 0
                                ? MeterCard(
                                    meter: meter,
                                    date: meter.lastEntry?.date,
                                    count: count,
                                    onTap: () {
                                      if (selectedMetersCount > 0) {
                                        ref
                                            .read(detailsRoomProvider(room.id!)
                                                .notifier)
                                            .toggleSelectMeterState(meter);
                                      } else {
                                        // TODO open details meter
                                      }
                                    },
                                  )
                                : _meterCardWithSlide(
                                    room: room,
                                    meter: meter,
                                    count: count,
                                    date: meter.lastEntry?.date,
                                    selectedMetersCount: selectedMetersCount,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _meterCardWithSlide({
    required MeterDto meter,
    required DateTime? date,
    required String count,
    required RoomDto room,
    required int selectedMetersCount,
  }) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await ref
                  .read(detailsRoomProvider(room.id!).notifier)
                  .removeMeterFromRoom(meter);
            },
            icon: Icons.playlist_remove,
            label: 'Entfernen',
            foregroundColor: Colors.white,
            backgroundColor: CustomColors.red,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
      child: MeterCard(
        meter: meter,
        date: date,
        count: count,
        onTap: () {
          if (selectedMetersCount > 0) {
            ref
                .read(detailsRoomProvider(room.id!).notifier)
                .toggleSelectMeterState(meter);
          } else {
            // TODO open details meter
          }
        },
      ),
    );
  }

  AppBar _selectedAppBar(int count) {
    return AppBar(
      title: Text('$count ausgewählt'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref
              .read(detailsRoomProvider(room.id!).notifier)
              .removeSelectedMetersState();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            ref
                .read(detailsRoomProvider(room.id!).notifier)
                .removeAllSelectedMetersFromRoom();
          },
          icon: const Icon(Icons.playlist_remove),
        ),
      ],
    );
  }

  AppBar _nonSelectedAppBar() {
    return AppBar(
      title: Text(room.name),
      actions: [
        _update == false
            ? IconButton(
                tooltip: 'Raum bearbeiten',
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _update = true;
                  });
                },
              )
            : IconButton(
                onPressed: () async {
                  if (room.name.isEmpty) {
                    room.name = room.typ;
                  }

                  await ref
                      .read(detailsRoomProvider(room.id!).notifier)
                      .updateRoom(room);

                  setState(() {
                    _update = false;
                  });
                },
                icon: const Icon(Icons.save),
                tooltip: 'Änderung speichern',
              )
      ],
    );
  }
}

class RoomDetails extends StatefulWidget {
  final RoomDto room;
  final bool update;
  final Function(String?) onSelectedRoomType;
  final Function(String) onRoomNameChange;

  const RoomDetails(
      {super.key,
      required this.room,
      required this.update,
      required this.onSelectedRoomType,
      required this.onRoomNameChange});

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    _name.text = widget.room.name;

    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        RoomTypeDropdown(
          selectedType: widget.room.typ,
          onChanged: widget.onSelectedRoomType,
        ),
        TextFormField(
          readOnly: !widget.update,
          onChanged: widget.onRoomNameChange,
          controller: _name,
          decoration: InputDecoration(
            label: const Text('Zimmername'),
            icon: const Icon(Icons.abc),
            enabled: widget.update,
            labelStyle: widget.update
                ? Theme.of(context).textTheme.bodyLarge
                : Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.grey),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
