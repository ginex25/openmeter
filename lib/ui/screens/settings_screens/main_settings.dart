import 'package:flutter/material.dart';
import 'package:openmeter/features/reminder/view/reading_reminder_tile.dart';
import 'package:openmeter/features/torch/view/active_torch_tile.dart';

import '../../../core/theme/widgets/desing_tile.dart';
import '../../../features/tags/view/tags_tile.dart';
import '../../widgets/settings_screen/database_listtile.dart';

class MainSettings extends StatelessWidget {
  const MainSettings({super.key});

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
