import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/room/model/meter_room_dto.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:openmeter/features/room/provider/all_room_list.dart';
import 'package:openmeter/features/room/widget/meter_card_compact.dart';

class AddMeterToRoom extends ConsumerStatefulWidget {
  final RoomDto room;

  const AddMeterToRoom(this.room, {super.key});

  @override
  ConsumerState createState() => _AddMeterToRoomState();
}

class _AddMeterToRoomState extends ConsumerState<AddMeterToRoom> {
  final TextEditingController _searchController = TextEditingController();

  late RoomDto room;

  final List<MeterDto> _selectedItemsWithoutExists = [];
  final List<MeterDto> _selectedItemsWithExists = [];

  String _searchText = '';
  List<MeterRoomDto> _searchItems = [];

  @override
  void initState() {
    room = widget.room;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _selectedItemsWithoutExists.clear();
    _selectedItemsWithExists.clear();

    super.dispose();
  }

  void searchForMeter(String value, List<MeterRoomDto> meters) {
    _searchItems = [];

    for (MeterRoomDto data in meters) {
      if (data.meter.number.toLowerCase().contains(value.toLowerCase())) {
        _searchItems.add(data);
      }
      if (data.meter.typ.toLowerCase().contains(value.toLowerCase())) {
        _searchItems.add(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final metersProvider = ref.watch(allRoomListProvider(room.id!));

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Zähler zuordnen'),
        ),
        floatingActionButton: SizedBox(
          width: 100,
          child: FloatingActionButton(
            onPressed: () async {
              await ref
                  .read(allRoomListProvider(room.id!).notifier)
                  .saveSelectedMeters(
                      selectedItemsWithExists: _selectedItemsWithExists,
                      selectedItemsWithoutExists: _selectedItemsWithoutExists,
                      room: room)
                  .then(
                (value) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
            child: const Text('Fertig'),
          ),
        ),
        body: metersProvider.when(
          data: (List<MeterRoomDto> meters) {
            return SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  _searchWidget(meters),
                  _meterList(_searchText.isNotEmpty ? _searchItems : meters),
                ],
              ),
            );
          },
          error: (error, stackTrace) => throw error,
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _meterList(List<MeterRoomDto> meters) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: meters.length,
        itemBuilder: (context, index) {
          final data = meters[index];

          bool isSelected = _selectedItemsWithExists.contains(data.meter) ||
              _selectedItemsWithoutExists.contains(data.meter);

          return Column(
            children: [
              MeterCompactTile(
                data: data,
                isSelected: isSelected,
                onSelect: () {
                  if (data.isInARoom == true) {
                    if (_selectedItemsWithExists.contains(data.meter)) {
                      _selectedItemsWithExists.remove(data.meter);
                    } else {
                      _selectedItemsWithExists.add(data.meter);
                    }
                  } else {
                    if (_selectedItemsWithoutExists.contains(data.meter)) {
                      _selectedItemsWithoutExists.remove(data.meter);
                    } else {
                      _selectedItemsWithoutExists.add(data.meter);
                    }
                  }

                  setState(() {});
                },
              ),
              if (index == meters.length - 1)
                const SizedBox(
                  height: 140,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _searchWidget(List<MeterRoomDto> meters) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: SearchBar(
        controller: _searchController,
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0),
        ),
        leading: const Icon(Icons.search),
        trailing: [
          if (_searchText.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchText = '';
                  _searchItems = [];
                });
              },
              icon: const Icon(Icons.clear),
            )
        ],
        hintText: 'Nummer oder Typ suchen',
        onChanged: (value) => setState(() {
          _searchText = value;
          searchForMeter(value, meters);
        }),
      ),
    );
  }
}
