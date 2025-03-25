import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/contract/provider/selected_contract_count.dart';
import 'package:openmeter/features/database_settings/model/autobackup_model.dart';
import 'package:openmeter/features/database_settings/provider/autobackup_provider.dart';
import 'package:openmeter/features/database_settings/provider/has_update.dart';
import 'package:openmeter/features/database_settings/provider/in_app_action.dart';
import 'package:openmeter/features/database_settings/repository/export_repository.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/room/provider/selected_room_count_provider.dart';

import '../../shared/constant/custom_icons.dart';
import '../../shared/constant/log.dart';
import 'homescreen.dart';
import 'objects.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool hasUpdate = false;
  bool isInAppAction = false;

  final List _screen = const [
    HomeScreen(),
    // StatsScreen(),
    ObjectsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final AutoBackupModel autoBackup = ref.watch(autoBackupProvider);
    log(state.toString(), name: LogNames.appLifecycle);

    if (autoBackup.backupIsPossible &&
        hasUpdate &&
        !isInAppAction &&
        state == AppLifecycleState.paused) {
      await ref.read(exportRepositoryProvider).runIsolateExportAsJson(
          path: autoBackup.path,
          isAutoBackup: true,
          clearBackupFiles: autoBackup.deleteOldBackups);

      ref.read(hasUpdateProvider.notifier).setState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    hasUpdate = ref.watch(hasUpdateProvider);
    isInAppAction = ref.watch(inAppActionProvider);

    final ThemeModel themeMode = ref.watch(themeModeProviderProvider);

    final int selectedMeters = ref.watch(selectedMetersCountProvider);
    final int selectedRooms = ref.watch(selectedRoomCountProvider);
    final int selectedContracts = ref.watch(selectedContractCountProvider);

    bool compactNavBar = themeMode.compactNavigation;

    bool hasSelectedItems = false;

    if (selectedMeters > 0 || selectedRooms > 0 || selectedContracts > 0) {
      hasSelectedItems = true;
    }

    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: hasSelectedItems
          ? null
          : NavigationBar(
              height: MediaQuery.of(context).size.height * 0.09,
              labelBehavior: compactNavBar
                  ? NavigationDestinationLabelBehavior.alwaysHide
                  : NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: _currentIndex,
              onDestinationSelected: (value) {
                if (selectedRooms > 0) {
                  ref.read(roomListProvider.notifier).removeAllSelectedState();
                }
                if (selectedContracts > 0) {
                  ref
                      .read(contractListProvider.notifier)
                      .removeAllSelectedState();
                }
                if (selectedMeters > 0) {
                  ref
                      .read(meterListProvider.notifier)
                      .removeAllSelectedMetersState();
                }

                setState(() {
                  _currentIndex = value;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(CustomIcons.voltmeter),
                  label: 'Zähler',
                ),
                NavigationDestination(
                  icon: Icon(Icons.widgets),
                  label: 'Objekte',
                ),
              ],
            ),
    );
  }
}
