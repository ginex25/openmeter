import 'package:flutter/material.dart';
import 'package:openmeter/core/theme/widgets/theme_title.dart';

import '../widgets/change_preview.dart';
import '../widgets/compact_nav_bar.dart';
import '../widgets/display_awake.dart';
import '../widgets/dynamic_color_tile.dart';
import '../widgets/font_size_tile.dart';

class DesignScreen extends StatefulWidget {
  const DesignScreen({super.key});

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Darstellung'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ChangePreview(),
                ),
                SizedBox(
                  height: 15,
                ),
                ThemeTitle(),
                DynamicColorTile(),
                CompactNavBarSettings(),
                FontSizeTile(),
                Divider(),
                DisplayAwake(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
