import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/service/permission_service.dart';
import 'package:openmeter/features/database_settings/model/autobackup_model.dart';
import 'package:openmeter/features/database_settings/provider/autobackup_provider.dart';
import 'package:openmeter/features/database_settings/provider/in_app_action.dart';

class AutoBackup extends ConsumerWidget {
  const AutoBackup({super.key});

  _toastEmptyDirectory(context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Es muss zuerst ein Backup Ordner ausgewählt werden!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  _selectAutoBackupPath(WidgetRef ref) async {
    bool permissionGranted =
        await PermissionService().askForExternalStoragePermission();

    if (!permissionGranted) {
      return;
    }

    ref.read(inAppActionProvider.notifier).setState(true);

    String? path = await FilePicker.platform.getDirectoryPath();

    ref.read(inAppActionProvider.notifier).setState(false);

    if (path == null) {
      return;
    }

    ref.read(autoBackupProvider.notifier).setSelectedPath(path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoBackupModel data = ref.watch(autoBackupProvider);

    return Column(
      children: [
        // toggle backup state
        SwitchListTile(
          title: Text(
            'Automatisches Backup',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: const Text(
              'Erstellt automatisch ein Backup der Datenbank sobald die App geschlossen wird.'),
          secondary: const Icon(Icons.settings_backup_restore),
          value: data.isActive,
          onChanged: (bool value) {
            if (data.path.isEmpty) {
              _toastEmptyDirectory(context);
              return;
            }

            ref.read(autoBackupProvider.notifier).setActiveState(value);
          },
        ),
        // Get backup directory
        ListTile(
          leading: const Icon(Icons.drive_folder_upload),
          title: Text(
            'Ordner für Datensicherung wählen',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: data.path.isEmpty
              ? const Text('Es wurde noch kein Verzeichnis ausgewählt')
              : Text(data.path),
          onTap: () {
            _selectAutoBackupPath(ref);
            // _databaseHelper.selectAutoBackupPath(provider);
          },
        ),
        SwitchListTile(
          title: Text(
            'Alte Backups löschen',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: const Text(
              'Es werden alle Backup Dateien gelöscht, bis auf die neusten zwei.'),
          secondary: const Icon(Icons.auto_delete_outlined),
          onChanged: (value) async {
            if (data.isActive) {
              ref.read(autoBackupProvider.notifier).setDeleteOldFiles(value);
            }
          },
          value: data.deleteOldBackups,
        ),
      ],
    );
  }
}
