import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/service/permission_service.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/database_settings/provider/in_app_action.dart';
import 'package:openmeter/features/database_settings/provider/stats_provider.dart';
import 'package:openmeter/features/database_settings/repository/delete_table_repository.dart';
import 'package:openmeter/features/database_settings/repository/export_repository.dart';
import 'package:openmeter/features/database_settings/repository/import_repository.dart';
import 'package:openmeter/features/database_settings/widget/auto_backup.dart';
import 'package:openmeter/features/database_settings/widget/stats_card.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/tags/provider/tag_list_provider.dart';
import 'package:openmeter/shared/widgets/custom_loading_indicator.dart';

class DatabaseView extends ConsumerStatefulWidget {
  const DatabaseView({super.key});

  @override
  ConsumerState createState() => _DatabaseViewState();
}

class _DatabaseViewState extends ConsumerState<DatabaseView> {
  final _permissionService = PermissionService();

  bool _isLoading = false;

  _showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }

  _handleExport() async {
    ref.read(inAppActionProvider.notifier).setState(true);

    bool hasPermission =
        await _permissionService.askForExternalStoragePermission();

    if (!hasPermission) {
      setState(() {
        _isLoading = false;
      });

      _showSnackbar('Es wurden keine Rechte erteilt.');

      return;
    }

    String? path = await FilePicker.platform.getDirectoryPath();

    if (path == null) {
      setState(() {
        _isLoading = false;
      });

      _showSnackbar('Es wurden kein Speicherort ausgewählt.');

      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool success = await ref
        .read(exportRepositoryProvider)
        .runIsolateExportAsJson(
            path: path, isAutoBackup: false, clearBackupFiles: false);

    ref.read(inAppActionProvider.notifier).setState(false);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Datenbank wurde erfolgreich exportiert!',
          ),
          behavior: SnackBarBehavior.floating,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Datenbank konnte nicht exportiert werden!',
          ),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  Future<void> _handleImport() async {
    ref.read(inAppActionProvider.notifier).setState(true);

    bool permissionGranted =
        await _permissionService.askForExternalStoragePermission();

    if (!permissionGranted) {
      ref.read(inAppActionProvider.notifier).setState(false);
      _showSnackbar('Es wurden keine Rechte erteilt.');
      return;
    }

    await FilePicker.platform.clearTemporaryFiles();

    FilePickerResult? path = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json', 'zip'],
      type: FileType.custom,
    );

    if (path == null) {
      ref.read(inAppActionProvider.notifier).setState(false);
      _showSnackbar('Es wurden keine Datei ausgewählt.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await ref
        .read(importRepositoryProvider)
        .importFromJson(path: path.files.single.path!);

    ref.read(inAppActionProvider.notifier).setState(false);

    setState(() {
      _isLoading = false;
    });

    ref.invalidate(databaseStatsProvider);
    ref.invalidate(tagListProvider);
    ref.invalidate(contractListProvider);
    ref.invalidate(roomListProvider);
    ref.invalidate(meterListProvider);
  }

  _deleteTableAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zurücksetzen?'),
        content: const Text(
            'Möchten Sie Ihre Datenbank wirklich zurücksetzen und somit alle Daten löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              final success =
                  await ref.read(deleteTableRepositoryProvider).deleteTable();

              if (success) {
                _showSnackbar('Datenbank wurde erfolgreich zurückgesetzt!');
              } else {
                _showSnackbar('Etwas ist schief gelaufen!');
              }

              ref.invalidate(databaseStatsProvider);
              ref.invalidate(tagListProvider);
              ref.invalidate(contractListProvider);
              ref.invalidate(roomListProvider);
              ref.invalidate(meterListProvider);

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Zurücksetzen',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daten und Speicher'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatabaseStatsCard(),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.cloud_upload),
                    title: Text(
                      'Daten exportieren',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: const Text(
                      'Erstelle und speichere ein Backup deiner Daten.',
                    ),
                    onTap: () {
                      _handleExport();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_download),
                    title: Text(
                      'Daten importieren',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: const Text(
                      'Importiere deine gespeicherten Daten.',
                    ),
                    onTap: () async {
                      await _handleImport();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(Icons.replay),
                    title: Text(
                      'Daten zurücksetzen',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: const Text(
                      'Lösche alle gespeicherten Daten.',
                    ),
                    onTap: () {
                      _deleteTableAlert();
                    },
                  ),
                  const Divider(),
                  const AutoBackup(),
                ],
              ),
            ),
            if (_isLoading == true) const CustomLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
