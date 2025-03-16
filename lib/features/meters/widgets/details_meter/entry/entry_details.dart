import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/meters/helper/entry_helper.dart';
import 'package:openmeter/features/meters/provider/details_meter_provider.dart';
import 'package:openmeter/features/meters/provider/entry_contract.dart';
import 'package:openmeter/features/meters/service/meter_image_service.dart';
import 'package:openmeter/shared/constant/custom_icons.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:openmeter/shared/utils/convert_count.dart';
import 'package:openmeter/shared/utils/convert_meter_unit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'image_view.dart';

class EntryDetails extends ConsumerStatefulWidget {
  final EntryDto entry;
  final MeterDto meter;

  const EntryDetails({
    super.key,
    required this.entry,
    required this.meter,
  });

  @override
  ConsumerState createState() => _EntryDetailsState();
}

class _EntryDetailsState extends ConsumerState<EntryDetails> {
  final ConvertMeterUnit convertMeterUnit = ConvertMeterUnit();
  final MeterImageService _meterImageHelper = MeterImageService();

  final FocusNode _noteFocus = FocusNode();

  final TextEditingController _noteController = TextEditingController();
  final PageController _pageController = PageController();

  late EntryDto entry;

  bool _isReset = false;
  bool _isTransmitted = false;
  int _selectedView = 0;
  bool _update = false;

  @override
  void initState() {
    _isReset = widget.entry.isReset;
    _isTransmitted = widget.entry.transmittedToProvider;
    _noteController.text = widget.entry.note ?? '';

    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();

    super.dispose();
  }

  Future<void> _updateEntry() async {
    entry.transmittedToProvider = _isTransmitted;
    entry.isReset = _isReset;
    entry.note = _noteController.text;

    await ref
        .read(detailsMeterProvider(widget.meter.id!).notifier)
        .updateEntry(entry)
        .then(
      (value) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    entry = widget.entry;

    int usage = entry.usage;

    if (entry.usage == entry.count && entry.days == 0) {
      usage = -1;
    }

    return Column(
      children: [
        Center(
          child: Container(
            height: 5,
            width: 30,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).highlightColor,
            ),
          ),
        ),
        ListView(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat(DateTimeFormats.dateGermanLong)
                          .format(entry.date),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    convertMeterUnit.getUnitWidget(
                      count: ConvertCount.convertCount(entry.count),
                      unit: widget.meter.unit,
                      textStyle: Theme.of(context).textTheme.bodyLarge!,
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (_selectedView == 1) _imagePopUpMenu(),
                    if (entry.imagePath == null) _showAddImagePopup(),
                    if (!_update && _selectedView == 0)
                      IconButton(
                        tooltip: 'Eintrag bearbeiten',
                        icon: Icon(
                          Icons.edit_note,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            _update = !_update;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
            const Divider(),
            SizedBox(
              height: 300,
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  if (_noteFocus.hasFocus) {
                    _noteFocus.unfocus();
                  }

                  setState(
                    () => _selectedView = value,
                  );
                },
                children: [
                  Column(
                    children: [
                      if (usage == -1 && !entry.isReset)
                        _extraInformation('Erstablesung'),
                      if (entry.isReset)
                        _extraInformation('Dieser Zähler wurde Zurückgesetzt.'),
                      if (usage == -1 || entry.isReset) const Divider(),
                      if (usage != -1)
                        Column(
                          children: [
                            EntityCost(
                              entry: entry,
                              meter: widget.meter,
                            ),
                            const Divider(),
                          ],
                        ),
                      SwitchListTile(
                        value: _isTransmitted,
                        onChanged: (value) {
                          if (_update) {
                            setState(
                              () => _isTransmitted = value,
                            );
                          }
                        },
                        title: const Text('An Anbieter gemeldet'),
                      ),
                      SwitchListTile(
                        value: _isReset,
                        onChanged: (value) {
                          if (_update) {
                            setState(
                              () => _isReset = value,
                            );
                          }
                        },
                        title: const Text('Zähler zurücksetzen'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: TextFormField(
                          controller: _noteController,
                          focusNode: _noteFocus,
                          readOnly: !_update,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.notes),
                            hintText: 'Füge eine Notiz hinzu',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (entry.imagePath != null && !_update)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => ImageView(
                            entry: entry,
                            meter: widget.meter,
                          ),
                        ))
                            .then((value) async {
                          bool deleteImage = value ?? false;

                          if (deleteImage) {
                            await _deleteImage();
                          }
                        });
                      },
                      child: Image.file(
                        scale: 0.5,
                        File(entry.imagePath!),
                      ),
                    ),
                ],
              ),
            ),
            if (entry.imagePath != null)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 8.0),
                child: AnimatedSmoothIndicator(
                  activeIndex: _selectedView,
                  count: 2,
                  effect: WormEffect(
                    activeDotColor: Theme.of(context).primaryColor,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
              ),
            if (_update)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      child: FilledButton(
                        onPressed: () async {
                          await _updateEntry();
                        },
                        child: const Text('Speichern'),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  _showAddImagePopup() {
    // final databaseSettingsProvider =
    // Provider.of<DatabaseSettingsProvider>(context, listen: false);

    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      icon: Icon(
        CustomIcons.photoadd,
        color: Theme.of(context).hintColor,
      ),
      tooltip: 'Füge ein Bild hinzu',
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          onTap: () async {
            // databaseSettingsProvider.toggleInAppActionState();

            String? imagePath =
                await _meterImageHelper.selectAndSaveImage(ImageSource.camera);

            // databaseSettingsProvider.toggleInAppActionState();

            setState(() {
              entry.imagePath = imagePath;

              ref
                  .read(detailsMeterProvider(widget.meter.id!).notifier)
                  .updateEntry(entry);

              if (entry.imagePath != null) {
                _selectedView = 1;
                _pageController.nextPage(
                    duration: Durations.short1, curve: Curves.linear);
              }
            });
          },
          child: Row(
            spacing: 15,
            children: [
              const Icon(
                Icons.camera_alt,
                size: 20,
              ),
              Text(
                'Bild aufnehmen',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          onTap: () async {
            // databaseSettingsProvider.toggleInAppActionState();

            String? imagePath =
                await _meterImageHelper.selectAndSaveImage(ImageSource.gallery);

            // databaseSettingsProvider.toggleInAppActionState();

            setState(() {
              entry.imagePath = imagePath;

              ref
                  .read(detailsMeterProvider(widget.meter.id!).notifier)
                  .updateEntry(entry);

              if (entry.imagePath != null) {
                _selectedView = 1;
                _pageController.nextPage(
                    duration: Durations.short1, curve: Curves.linear);
              }
            });
          },
          child: Row(
            spacing: 15,
            children: [
              const Icon(
                Icons.photo_library,
                size: 20,
              ),
              Text(
                'Bild aus der Galerie wählen',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _imagePopUpMenu() {
    // final databaseSettingsProvider =
    // Provider.of<DatabaseSettingsProvider>(context, listen: false);

    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tooltip: 'Teilen oder löschen von dem Bild',
      icon: Icon(
        CustomIcons.photoedit,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          onTap: () async {
            bool success = await _meterImageHelper
                .saveImageToGallery(File(entry.imagePath!));

            if (context.mounted) {
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Bild wurde in der Galerie gespeichert!',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Bild konnte nicht in die Galerie gespeichert werden!',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
          child: Row(
            children: [
              const Icon(
                Icons.save_alt,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Bild in die Galerie speichern',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          onTap: () async {
            // databaseSettingsProvider.toggleInAppActionState();

            await Share.shareXFiles([XFile(entry.imagePath!)]);

            // databaseSettingsProvider.toggleInAppActionState();
          },
          child: Row(
            children: [
              const Icon(
                Icons.share,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Bild teilen',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () async {
            await _meterImageHelper.deleteImage(entry.imagePath!);

            await _deleteImage();
          },
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Bild löschen',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _extraInformation(String s) {
    return Center(
      child: Text(s, style: Theme.of(context).textTheme.labelLarge!),
    );
  }

  _deleteImage() async {
    setState(() {
      entry.imagePath = null;
      _selectedView = 0;
    });

    await ref
        .read(detailsMeterProvider(widget.meter.id!).notifier)
        .updateEntry(entry);
  }
}

class EntityCost extends ConsumerWidget {
  final EntryDto entry;
  final MeterDto meter;

  const EntityCost({
    super.key,
    required this.entry,
    required this.meter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ConvertMeterUnit convertMeterUnit = ConvertMeterUnit();
    final EntryHelper entryHelper = EntryHelper();

    final provider = ref.watch(entryContractProvider(meter));

    return provider.when(
      data: (data) {
        if (data == null) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      convertMeterUnit.getUnitWidget(
                        count: '+${ConvertCount.convertCount(entry.usage)}',
                        unit: meter.unit,
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: entryHelper.getColors(
                                      entry.count, entry.usage),
                                ),
                      ),
                      Text(
                        'innerhalb ${entry.days} Tagen',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      convertMeterUnit.getUnitWidget(
                        count:
                            entryHelper.getDailyUsage(entry.usage, entry.days),
                        unit: meter.unit,
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: entryHelper.getColors(
                                      entry.count, entry.usage),
                                ),
                      ),
                      Text(
                        'pro Tag',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Für mehr Information füge einen Vertrag hinzu.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        double usageCost = entryHelper.calcUsageForContract(
            entry.usage, data.costs.energyPrice);
        double dailyCost = usageCost / entry.days;

        final String local = Platform.localeName;
        final costFormat = NumberFormat.simpleCurrency(locale: local);

        return Column(
          children: [
            // full days
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    convertMeterUnit.getUnitWidget(
                      count: '+${ConvertCount.convertCount(entry.usage)}',
                      unit: meter.unit,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: entryHelper.getColors(
                                  entry.count,
                                  entry.usage,
                                ),
                              ),
                    ),
                    Text(
                      costFormat.format(usageCost),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Text(
                  'innerhalb ${entry.days} Tagen',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            // Daily
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    convertMeterUnit.getUnitWidget(
                      count: entryHelper.getDailyUsage(entry.usage, entry.days),
                      unit: meter.unit,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: entryHelper.getColors(
                                  entry.count,
                                  entry.usage,
                                ),
                              ),
                    ),
                    Text(
                      costFormat.format(dailyCost),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Text(
                  'pro Tag',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ],
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
