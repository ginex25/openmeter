import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/service/permission_service.dart';
import 'package:openmeter/features/database_settings/repository/export_repository.dart';
import 'package:openmeter/features/database_settings/widget/auto_backup.dart';
import 'package:openmeter/features/database_settings/widget/stats_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onTap: () {
                    // TODO impl import
                    // _handleImport(db, provider, meterProvider);
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
                    // TODO handle delete
                    // _databaseHelper.deleteDB(context, db);
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
    );
  }
}
