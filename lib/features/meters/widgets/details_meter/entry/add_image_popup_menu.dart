import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openmeter/features/meters/service/meter_image_service.dart';
import 'package:openmeter/shared/constant/custom_icons.dart';

class AddImagePopupMenu extends ConsumerStatefulWidget {
  final String? imagePath;
  final Function beforeOnTap;
  final Function afterImageDelete;
  final Function(String? imagePath) afterCameraSelect;
  final Function(String? imagePath) afterGallerySelect;

  const AddImagePopupMenu({
    super.key,
    this.imagePath,
    required this.beforeOnTap,
    required this.afterImageDelete,
    required this.afterCameraSelect,
    required this.afterGallerySelect,
  });

  @override
  ConsumerState createState() => _ImagePopupMenuState();
}

class _ImagePopupMenuState extends ConsumerState<AddImagePopupMenu> {
  final _iconKey = GlobalKey();

  final MeterImageService _imageHelper = MeterImageService();

  String? imagePath;

  _showAddImagePopupMenu(BuildContext context, Offset offset) {
    // final databaseSettingsProvider =
    //     Provider.of<DatabaseSettingsProvider>(context, listen: false);

    double left = offset.dx;
    double top = offset.dy; // MediaQuery.sizeOf(context).height * 0.44;

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.camera_alt,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Bild aufnehmen',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          onTap: () async {
            // databaseSettingsProvider.toggleInAppActionState();

            String? imagePath =
                await _imageHelper.selectAndSaveImage(ImageSource.camera);

            widget.afterCameraSelect(imagePath);

            // databaseSettingsProvider.toggleInAppActionState();
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.photo_library,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Bild aus der Galerie wählen',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          onTap: () async {
            // databaseSettingsProvider.toggleInAppActionState();

            String? imagePath =
                await _imageHelper.selectAndSaveImage(ImageSource.gallery);

            // databaseSettingsProvider.toggleInAppActionState();

            widget.afterGallerySelect(imagePath);
          },
        ),
        if (widget.imagePath != null)
          PopupMenuItem(
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
            onTap: () async {
              await _imageHelper.deleteImage(widget.imagePath!);

              widget.afterImageDelete();
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    imagePath = widget.imagePath;

    return IconButton(
      key: _iconKey,
      tooltip: imagePath == null
          ? 'Füge ein Bild hinzu'
          : 'Füge ein neues Bild hinzu oder lösche das aktuelle',
      icon: imagePath == null
          ? const Icon(
              CustomIcons.photoadd,
              size: 26,
            )
          : const Icon(
              CustomIcons.photoedit,
              size: 26,
            ),
      onPressed: () async {
        await widget.beforeOnTap();

        RenderBox renderBox =
            _iconKey.currentContext?.findRenderObject() as RenderBox;

        Offset offset = renderBox.localToGlobal(Offset.zero);

        if (context.mounted) {
          _showAddImagePopupMenu(context, offset);
        }
      },
    );
  }
}
