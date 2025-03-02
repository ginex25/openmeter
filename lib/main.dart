import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:openmeter/core/provider/entry_filter_provider.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/features/tags/view/tags_screen.dart';
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
import 'core/provider/reminder_provider.dart';
import 'core/provider/room_provider.dart';
import 'core/provider/small_feature_provider.dart';
import 'core/provider/sort_provider.dart';
import 'core/provider/stats_provider.dart';
import 'core/provider/theme_changer.dart';
import 'features/contract/view/archive_contracts.dart';
import 'ui/screens/meters/archived_meters.dart';
import 'ui/screens/settings_screens/database_screen.dart';
import 'ui/screens/settings_screens/design_screen.dart';
import 'ui/screens/settings_screens/main_settings.dart';
import 'ui/screens/settings_screens/reminder_screen.dart';
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

class MyApp extends StatelessWidget {
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
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _cacheImages(context);

    return p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider<ThemeChanger>.value(value: ThemeChanger()),
        p.ChangeNotifierProvider<CostProvider>.value(value: CostProvider()),
        p.ChangeNotifierProvider<SortProvider>.value(value: SortProvider()),
        p.ChangeNotifierProvider<RefreshProvider>.value(
            value: RefreshProvider()),
        p.ChangeNotifierProvider<ReminderProvider>.value(
            value: ReminderProvider()),
        p.ChangeNotifierProvider<SmallFeatureProvider>.value(
            value: SmallFeatureProvider()),
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
      child: p.Consumer<ThemeChanger>(
        builder: (context, themeChanger, child) => DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            final useDynamic = themeChanger.getUseDynamicColor;

            if (useDynamic) {
              themeChanger.setDynamicColors(lightDynamic, darkDynamic);
            }

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
              theme: themeChanger.getLightTheme(),
              darkTheme: themeChanger.getNightMode
                  ? themeChanger.getNightTheme()
                  : themeChanger.getDarkTheme(),
              themeMode: themeChanger.getThemeMode,
              initialRoute: '/',
              routes: {
                '/': (_) => const BottomNavBar(),
                // 'add_meter': (_) => AddScreen(),
                // 'add_contract': (_) => const AddContract(),
                'settings': (_) => const MainSettings(),
                // 'details_single_meter': (_) => DetailsSingleMeter(),
                'reminder': (_) => const ReminderScreen(),
                'database_export_import': (_) => const DatabaseExportImport(),
                'tags_screen': (_) => const TagsScreen(),
                'archive': (_) => const ArchivedMeters(),
                'archive_contract': (_) => const ArchiveContract(),
                'design_settings': (_) => const DesignScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
