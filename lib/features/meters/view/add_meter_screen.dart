import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openmeter/core/service/torch_service.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/features/meters/model/details_meter_model.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/details_meter_provider.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/meters/widgets/meter_type_dropdown.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:openmeter/features/room/widget/room_dropdown.dart';
import 'package:openmeter/features/tags/model/tag_dto.dart';
import 'package:openmeter/features/tags/provider/tag_list_provider.dart';
import 'package:openmeter/features/tags/widget/add_tags.dart';
import 'package:openmeter/features/tags/widget/tag_chip.dart';
import 'package:openmeter/shared/constant/meter_typ.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';

class AddMeterScreen extends ConsumerStatefulWidget {
  final DetailsMeterModel? detailsMeter;

  const AddMeterScreen({super.key, this.detailsMeter});

  @override
  ConsumerState createState() => _AddMeterScreenState();
}

class _AddMeterScreenState extends ConsumerState<AddMeterScreen> {
  final TextEditingController _meterNumber = TextEditingController();
  final TextEditingController _meterNote = TextEditingController();
  final TextEditingController _meterValue = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late TorchService _torchService;
  bool isTorchOn = false;

  String _meterType = 'Stromzähler';
  String _roomId = "-2"; // -2: not selected, -1: no part of room
  String _pageTitle = 'Neuer Zähler';
  bool _updateMeterState = false;

  final List<String> _tagsId = [];
  String _meterUnit = 'kWh';

  RoomDto? _room;

  @override
  void initState() {
    if (widget.detailsMeter == null) {
      return;
    }

    _setController();

    if (widget.detailsMeter?.room != null) {
      _roomId = widget.detailsMeter!.room!.uuid;
      _room = widget.detailsMeter!.room!;
    } else {
      _roomId = "-1";
    }

    final MeterDto meter = widget.detailsMeter!.meter;

    _meterUnit = meter.unit;

    if (meter.tags.isNotEmpty) {
      _tagsId.addAll(meter.tags);
    }

    super.initState();
  }

  @override
  void dispose() {
    _meterNote.dispose();
    _meterNumber.dispose();
    _meterValue.dispose();

    super.dispose();
  }

  /*
    init values when meter is to be updated
   */
  void _setController() {
    final MeterDto meter = widget.detailsMeter!.meter;

    _pageTitle = meter.number;
    _meterNumber.text = meter.number;
    _meterNote.text = meter.note;
    _meterType = meter.typ;
    _updateMeterState = true;
  }

  void handleOnSave() async {
    if (_formKey.currentState!.validate()) {
      final MeterDto meter = MeterDto(
          unit: _meterUnit,
          number: _meterNumber.text,
          typ: _meterType,
          note: _meterNote.text,
          tags: []);

      if (_updateMeterState) {
        await ref
            .read(detailsMeterProvider(widget.detailsMeter!.meter.id!).notifier)
            .updateMeter(meter, _room, _tagsId)
            .then(
          (value) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      } else {
        await ref
            .read(meterListProvider.notifier)
            .createMeter(meter, int.parse(_meterValue.text), _room, _tagsId)
            .then(
          (value) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    _torchService = ref.watch(torchServiceProvider);
    isTorchOn = _torchService.stateTorch;

    bool darkMode = theme.mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        actions: [
          IconButton(
            onPressed: () async {
              bool isOn = await _torchService.getTorch();
              setState(() {
                isTorchOn = isOn;
              });
            },
            icon: _torchService.stateTorch
                ? Icon(
                    Icons.flashlight_on,
                    color: darkMode ? Colors.white : Colors.black,
                  )
                : Icon(
                    Icons.flashlight_off,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => handleOnSave(),
        label: const Text('Speichern'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              spacing: 15,
              children: [
                MeterTypeDropdown(
                  defaultValue: _meterType,
                  onChanged: (value) {
                    String typ = value ?? 'Stromzähler';

                    final meterTyp = meterTyps
                        .firstWhere((element) => element.meterTyp == value);

                    setState(() {
                      _meterUnit = meterTyp.unit;
                      _meterType = typ;
                    });
                  },
                ),
                UnitInput(
                  unit: _meterUnit,
                  onChange: (unit) {
                    setState(() {
                      _meterUnit = unit;
                    });
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe eine Zählernummer ein!';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  controller: _meterNumber,
                  decoration: const InputDecoration(
                      label: Text('Zählernummer'),
                      icon: Icon(Icons.onetwothree_outlined)),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _meterNote,
                  decoration: const InputDecoration(
                      label: Text('Notiz'),
                      icon: Icon(Icons.drive_file_rename_outline)),
                ),
                if (!_updateMeterState)
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gebe den aktuellen Zählerstand ein!';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: _meterValue,
                    decoration: const InputDecoration(
                      label: Text('Aktueller Zählerstand'),
                      // icon: Icon(Icons.assessment_outlined),
                      icon: FaIcon(
                        FontAwesomeIcons.chartSimple,
                        size: 16,
                      ),
                    ),
                  ),
                RoomDropdown(
                  roomId: _roomId,
                  onRoomSelected: (room) {
                    _room = room;
                  },
                ),
                MeterAddTags(
                  selectedTags: _tagsId,
                  onTagSelect: (tag) {
                    if (_tagsId.contains(tag.uuid)) {
                      _tagsId.remove(tag.uuid);
                    } else {
                      _tagsId.add(tag.uuid!);
                    }

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UnitInput extends StatefulWidget {
  final String unit;
  final Function(String)? onChange;

  const UnitInput({super.key, required this.unit, this.onChange});

  @override
  State<UnitInput> createState() => _UnitInputState();
}

class _UnitInputState extends State<UnitInput> {
  final ConvertMeterUnit convertMeterUnit = ConvertMeterUnit();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.unit;

    return Row(
      children: [
        Flexible(
          child: TextFormField(
            textInputAction: TextInputAction.next,
            controller: _controller,
            decoration: const InputDecoration(
                icon: FaIcon(
                  FontAwesomeIcons.ruler,
                  size: 16,
                ),
                label: Text('Einheit'),
                hintText: 'm^3 entspricht m\u00B3'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte geben Sie eine Einheit an!';
              }
              return null;
            },
            onChanged: widget.onChange,
          ),
        ),
        Column(
          children: [
            const Text(
              'Vorschau',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            convertMeterUnit.getUnitWidget(
              count: '',
              unit: widget.unit,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MeterAddTags extends ConsumerWidget {
  final Function(TagDto) onTagSelect;
  final List<String> selectedTags;

  const MeterAddTags({
    super.key,
    required this.onTagSelect,
    required this.selectedTags,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsProvider = ref.watch(tagListProvider);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Tags'),
            leading: FaIcon(
              FontAwesomeIcons.tags,
              size: 20,
              color: Theme.of(context).hintColor,
            ),
            onTap: () async {
              return showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return AddTagContent();
                },
              );
            },
            trailing: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
          ),
          tagsProvider.when(
            data: (tags) {
              if (tags.isEmpty) {
                return Container();
              }

              return SizedBox(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      Widget child = Container();

                      if (selectedTags.contains(tags[index].uuid)) {
                        child = Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckedTag(
                            tag: tags[index],
                          ),
                        );
                      } else {
                        child = Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SimpleTag(
                            tag: tags[index],
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () => onTagSelect(tags[index]),
                        child: SizedBox(width: 120, child: child),
                      );
                    }),
              );
            },
            error: (error, stackTrace) => throw error,
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
