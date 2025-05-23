import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/provider/rootIsolateToken.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/core/theme/repository/get_themes.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/database_settings/provider/stats_provider.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/meters/view/archived_meters_screen.dart';
import 'package:openmeter/features/reminder/service/local_notification_service.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/tags/view/tags_screen.dart';
import 'package:openmeter/screens/bottom_nav_bar.dart';
import 'package:openmeter/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/service/torch_service.dart';
import 'core/theme/view/design_screen.dart';
import 'features/contract/view/archive_contracts.dart';
import 'features/database_settings/view/database_view.dart';
import 'features/reminder/view/reminder_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

  final SharedPreferencesWithCache pref =
      await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions());

  final TorchService torchService = TorchService();
  await torchService.getTorch(isInit: true);

  final LocalNotificationService localNotificationService =
      LocalNotificationService();

  await localNotificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(pref),
        torchServiceProvider.overrideWithValue(torchService),
        rootIsolateTokenProvider.overrideWithValue(rootIsolateToken),
        localNotificationServiceProvider
            .overrideWithValue(localNotificationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  _cacheImages(BuildContext context) {
    // reminder images
    precacheImage(
        const AssetImage('assets/icons/notifications_disable.png'), context);
    precacheImage(
        const AssetImage('assets/icons/notifications_enable.png'), context);

    // chart image
    precacheImage(const AssetImage('assets/icons/no_data.png'), context);

    // Settings screens
    precacheImage(const AssetImage('assets/icons/database_icon.png'), context);
    precacheImage(const AssetImage('assets/icons/tag.png'), context);

    precacheImage(const AssetImage('assets/icons/empty_archiv.png'), context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsFlutterBinding.ensureInitialized();
    _cacheImages(context);

    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Theme.of(context).brightness,
        systemNavigationBarContrastEnforced: true,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return _EagerInitialization(
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          final bool useDynamic = theme.dynamicColor;

          final ColorScheme? darkScheme = useDynamic ? darkDynamic : null;

          return MaterialApp(
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('de', ''),
              Locale('en', ''),
            ],
            title: 'OpenMeter',
            debugShowCheckedModeBanner: false,
            theme: GetThemes.getLightTheme(
                useDynamic ? lightDynamic : null, theme.fontSize),
            darkTheme: theme.amoled
                ? GetThemes.getNightTheme(darkScheme, theme.fontSize)
                : GetThemes.getDarkTheme(darkScheme, theme.fontSize),
            themeMode: theme.mode,
            initialRoute: '/',
            routes: {
              '/': (_) => const BottomNavBar(),
              // 'add_meter': (_) => AddScreen(),
              // 'add_contract': (_) => const AddContract(),
              'settings': (_) => const SettingsScreen(),
              // 'details_single_meter': (_) => DetailsSingleMeter(),
              'reminder': (_) => const ReminderScreen(),
              'database_export_import': (_) => const DatabaseView(),
              'tags_screen': (_) => const TagsScreen(),
              'archive': (_) => const ArchivedMetersScreen(),
              'archive_contract': (_) => const ArchiveContract(),
              'design_settings': (_) => const DesignScreen(),
            },
          );
        },
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(meterListProvider);
    ref.watch(roomListProvider);
    ref.watch(contractListProvider);
    ref.watch(databaseStatsProvider);

    return child;
  }
}
