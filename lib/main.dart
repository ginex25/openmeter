import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:openmeter/core/provider/entry_filter_provider.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';
import 'package:openmeter/core/theme/repository/get_themes.dart';
import 'package:openmeter/features/meters/view/archived_meters_screen.dart';
import 'package:openmeter/features/tags/view/tags_screen.dart';
import 'package:openmeter/ui/screens/settings_screen.dart';
import 'package:provider/provider.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/database/local_database.dart';
import 'core/provider/chart_provider.dart';
import 'core/provider/contract_provider.dart';
import 'core/provider/cost_provider.dart';
import 'core/provider/database_settings_provider.dart';
import 'core/provider/design_provider.dart';
import 'core/provider/details_contract_provider.dart';
import 'core/provider/entry_provider.dart';
import 'core/provider/meter_provider.dart';
import 'core/provider/refresh_provider.dart';
import 'core/provider/room_provider.dart';
import 'core/provider/stats_provider.dart';
import 'core/theme/view/design_screen.dart';
import 'features/contract/view/archive_contracts.dart';
import 'features/database_settings/view/database_view.dart';
import 'features/reminder/view/reminder_screen.dart';
import 'ui/widgets/utils/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final SharedPreferencesWithCache pref =
      await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions());

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(pref),
      ],
      child: p.Provider<LocalDatabase>(
        create: (context) => LocalDatabase(),
        child: const MyApp(),
        dispose: (context, db) => db.close(),
      ),
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

    return p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider<CostProvider>.value(value: CostProvider()),
        p.ChangeNotifierProvider<RefreshProvider>.value(
            value: RefreshProvider()),
        p.ChangeNotifierProvider<EntryProvider>.value(value: EntryProvider()),
        p.ChangeNotifierProvider<ChartProvider>.value(value: ChartProvider()),
        p.ChangeNotifierProvider<StatsProvider>.value(value: StatsProvider()),
        p.ChangeNotifierProvider<DatabaseSettingsProvider>.value(
            value: DatabaseSettingsProvider()),
        p.ChangeNotifierProvider<RoomProvider>.value(value: RoomProvider()),
        p.ChangeNotifierProvider<ContractProvider>.value(
            value: ContractProvider()),
        p.ChangeNotifierProvider<MeterProvider>.value(value: MeterProvider()),
        p.ChangeNotifierProvider<DetailsContractProvider>.value(
            value: DetailsContractProvider()),
        p.ChangeNotifierProvider<DesignProvider>.value(value: DesignProvider()),
        p.ChangeNotifierProvider<EntryFilterProvider>.value(
            value: EntryFilterProvider()),
      ],
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
