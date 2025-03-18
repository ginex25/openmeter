import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/features/database_settings/provider/in_app_action.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/utils/convert_count.dart';
import '../../../../../shared/utils/convert_meter_unit.dart';
import '../../../model/entry_dto.dart';
import '../../../service/meter_image_service.dart';

class ImageView extends ConsumerStatefulWidget {
  final EntryDto entry;
  final MeterDto meter;

  const ImageView({super.key, required this.meter, required this.entry});

  @override
  ConsumerState<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends ConsumerState<ImageView>
    with SingleTickerProviderStateMixin {
  final MeterImageService _meterImageHelper = MeterImageService();

  final _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;

  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  final double _scale = 5;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });

    super.initState();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String meterNumber = widget.meter.number;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meterNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ConvertMeterUnit().getUnitWidget(
                  count: ConvertCount.convertCount(widget.entry.count),
                  unit: widget.meter.unit,
                  textStyle: Theme.of(context).textTheme.bodyMedium!,
                ),
              ],
            ),
            Text(
              DateFormat(DateTimeFormats.dateGermanLong)
                  .format(widget.entry.date),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onDoubleTapDown: (details) => _doubleTapDetails = details,
        onDoubleTap: () {
          final positions = _doubleTapDetails!.localPosition;

          final x = -positions.dx * (_scale - 1);
          final y = -positions.dy * (_scale - 1.5);

          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(_scale);

          final value = _transformationController.value.isIdentity()
              ? zoomed
              : Matrix4.identity();

          _animation =
              Matrix4Tween(begin: _transformationController.value, end: value)
                  .animate(CurveTween(curve: Curves.easeOut)
                      .animate(_animationController));

          _animationController.forward(from: 0);
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.2,
          maxScale: _scale,
          child: Center(child: Image.file(File(widget.entry.imagePath!))),
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  _createButtons(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Icon(
            icon,
            size: 25,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }

  _bottomBar() {
    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).textTheme.bodyLarge!.color,
      ),
    );

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Card(
        child: Table(
          children: [
            TableRow(
              children: [
                TextButton(
                  onPressed: () async {
                    bool success = await _meterImageHelper
                        .saveImageToGallery(File(widget.entry.imagePath!));

                    if (mounted) {
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
                  style: buttonStyle,
                  child: _createButtons(
                    Icons.save_alt,
                    'Speichern',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    ref.read(inAppActionProvider.notifier).setState(true);
                    await Share.shareXFiles([XFile(widget.entry.imagePath!)])
                        .then(
                      (value) =>
                          ref.read(inAppActionProvider.notifier).setState(true),
                    );
                  },
                  child: _createButtons(
                    Icons.share,
                    'Teilen',
                  ),
                  style: buttonStyle,
                ),
                TextButton(
                  onPressed: () async {
                    await _meterImageHelper
                        .deleteImage(widget.entry.imagePath!)
                        .then((value) {
                      if (mounted) {
                        Navigator.of(context).pop(true);
                      }
                    });
                  },
                  child: _createButtons(
                    Icons.delete_outline,
                    'Löschen',
                  ),
                  style: buttonStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
