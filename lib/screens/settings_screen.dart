import 'package:flutter/material.dart';
import 'package:openmeter/features/reminder/view/reading_reminder_tile.dart';
import 'package:openmeter/features/torch/view/active_torch_tile.dart';

import '../../core/theme/widgets/desing_tile.dart';
import '../../features/database_settings/view/database_listtile.dart';
import '../../features/tags/view/tags_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DesignTile(),
              DatabaseSettings(),
              Divider(),
              ReadingReminderTile(),
              TagsTile(),
              ActiveTorchTile(),
            ],
          ),
        ),
      ),
    );
  }
}
