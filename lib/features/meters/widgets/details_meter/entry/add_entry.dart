import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/features/meters/provider/current_details_meter.dart';
import 'package:openmeter/features/meters/provider/details_meter_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/helper/torch_controller.dart';
import '../../../../../core/model/meter_dto.dart';
import 'add_image_popup_menu.dart';

class AddEntry extends ConsumerStatefulWidget {
  const AddEntry({super.key});

  @override
  ConsumerState<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends ConsumerState<AddEntry> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _countFocus = FocusNode();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _counterController = TextEditingController();
  final TorchController _torchController = TorchController();
  final PageController _pageController = PageController();

  DateTime? _selectedDate = DateTime.now();
  bool _stateTorch = false;
  bool _isReset = false;
  bool _isTransmitted = false;

  int _selectedWidgetView = 0;
  String? _imagePath;
  int _firstOpen = 0;

  late MeterDto meter;

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _counterController.dispose();
    _countFocus.dispose();
  }

  void _showDatePicker() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
      locale: const Locale('de', ''),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      _selectedDate = pickedDate;
      _dateController.text = DateFormat('dd.MM.yyyy').format(_selectedDate!);
    });
  }

  _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final int count = _counterController.text.isEmpty
          ? 0
          : int.parse(_counterController.text);

      final entry = EntryDto(
        count: count,
        date: _selectedDate ?? DateTime.now(),
        meterId: meter.id!,
        isReset: _isReset,
        transmittedToProvider: _isTransmitted,
        imagePath: _imagePath,
      );

      await ref
          .read(detailsMeterProvider(meter.id!).notifier)
          .addEntry(entry)
          .then(
        (value) {
          _counterController.clear();
          _selectedDate = DateTime.now();
        },
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  _switchTiles(Function setState) {
    return Column(
      children: [
        SwitchListTile(
          value: _isTransmitted,
          onChanged: (value) {
            setState(
              () => _isTransmitted = value,
            );
          },
          title: const Text('An Anbieter gemeldet'),
        ),
        SwitchListTile(
          value: _isReset,
          onChanged: (value) {
            setState(
              () => _isReset = value,
            );
          },
          title: const Text('Zähler zurücksetzen'),
        ),
      ],
    );
  }

  void onImageSelect(String? imagePath, Function setState) {
    setState(() {
      _imagePath = imagePath;

      if (_imagePath != null) {
        _selectedWidgetView = 1;
        _pageController.nextPage(
            duration: Durations.short1, curve: Curves.linear);
      }
    });
  }

  _topBar(Function setState) {
    bool isTorchOn = _torchController.stateTorch;

    // if (torchProvider.stateTorch && !_torchController.stateTorch) {
    //   _torchController.getTorch();
    //   _stateTorch = true;
    //   isTorchOn = true;
    // }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Neuer Zählerstand',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                bool torch = await _torchController.getTorch();
                setState(() {
                  if (torch) {
                    isTorchOn = !isTorchOn;
                    // torchProvider.setIsTorchOn(isTorchOn);
                  }
                });
              },
              tooltip: isTorchOn
                  ? 'Schalte die Taschenlampe aus'
                  : 'Schalte die Taschenlampe an',
              icon: isTorchOn
                  ? const Icon(
                      Icons.flashlight_on,
                    )
                  : const Icon(
                      Icons.flashlight_off,
                    ),
            ),
            AddImagePopupMenu(
              beforeOnTap: () async {
                if (_countFocus.hasFocus) {
                  _countFocus.unfocus();
                  await Future.delayed(const Duration(milliseconds: 250));
                }
              },
              afterCameraSelect: (imagePath) =>
                  onImageSelect(imagePath, setState),
              afterGallerySelect: (imagePath) =>
                  onImageSelect(imagePath, setState),
              afterImageDelete: () {
                setState(() {
                  _imagePath = null;
                  _selectedWidgetView = 0;
                });
              },
              imagePath: _imagePath,
            ),
          ],
        ),
      ],
    );
  }

  _addView(Function setState) {
    if (_firstOpen < 2) {
      _firstOpen++;
    }

    return Column(
      children: [
        TextFormField(
          readOnly: true,
          textInputAction: TextInputAction.next,
          controller: _dateController
            ..text = _selectedDate != null
                ? DateFormat('dd.MM.yyyy').format(_selectedDate!)
                : '',
          onTap: () => _showDatePicker(),
          decoration: const InputDecoration(
              icon: Icon(Icons.date_range), label: Text('Datum')),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            autofocus: _firstOpen <= 1,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null) {
                return 'Bitte geben sie den Zählerstand an!';
              }
              if (value.isEmpty && !_isReset) {
                return 'Bitte geben sie den Zählerstand an!';
              }
              if (value.contains(',') || value.contains('.')) {
                return 'Bitte nutze keine Sonderzeichen!';
              }
              if (value.isNotEmpty && int.parse(value) < 0) {
                return 'Bitte gebe eine positive Zahl an!';
              }

              return null;
            },
            controller: _counterController,
            focusNode: _countFocus,
            decoration: const InputDecoration(
              icon: Icon(Icons.onetwothree),
              label: Text('Zählerstand'),
            )),
        const SizedBox(
          height: 20,
        ),
        const Divider(),
        _switchTiles(setState),
      ],
    );
  }

  _imageView() {
    return Image.file(
      File(_imagePath!),
      height: 150,
    );
  }

  _mainView(Function setState) {
    return Column(
      children: [
        SizedBox(
          height: 325,
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() => _selectedWidgetView = value);
            },
            children: [
              _addView(setState),
              if (_imagePath != null) _imageView(),
            ],
          ),
        ),
        if (_imagePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AnimatedSmoothIndicator(
              activeIndex: _selectedWidgetView,
              count: 2,
              effect: WormEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
      ],
    );
  }

  _showBottomModel() {
    // _torchController.setStateTorch(torchProvider.getStateIsTorchOn);

    final detailsMeter = ref.watch(currentDetailsMeterProvider);

    _counterController.text = detailsMeter.predictCount;
    meter = detailsMeter.meter;

    return showModalBottomSheet(
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 500,
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 15,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _topBar(setState),
                          _mainView(setState),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton.extended(
                              onPressed: () => _saveEntry(),
                              label: const Text('Speichern'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      if (_torchController.stateTorch && _stateTorch) {
        _torchController.getTorch();
      }

      _resetFields();
    });
  }

  _resetFields() async {
    _isReset = false;
    _selectedDate = DateTime.now();
    _counterController.clear();
    _stateTorch = false;
    _isTransmitted = false;
    _selectedWidgetView = 0;
    _firstOpen = 0;
    _imagePath = null;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _showBottomModel();
      },
      icon: const Icon(Icons.add),
      tooltip: 'Eintrag erstellen',
    );
  }
}
