import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/database_settings/widget/auto_backup.dart';
import 'package:openmeter/features/database_settings/widget/stats_card.dart';

class DatabaseView extends ConsumerWidget {
  const DatabaseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daten und Speicher'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
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
                    // TODO impl export
                    // _handleExport(db, provider);
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
            // if (_loadData == true)
            //   Container(
            //     height: MediaQuery.of(context).size.height,
            //     alignment: Alignment.center,
            //     child: const SizedBox(
            //       height: 80,
            //       width: 80,
            //       child: CircularProgressIndicator(strokeWidth: 8),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
