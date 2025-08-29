import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/provider/contract_list_provider.dart';
import 'package:openmeter/features/database_settings/repository/stats_repository.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/tags/provider/tag_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/stats_model.dart';

part 'stats_provider.g.dart';

@Riverpod(keepAlive: true)
Future<DatabaseStatsModel> databaseStats(Ref ref) async {
  final repo = ref.watch(databaseStatsRepositoryProvider);

  ref.listen(
    meterListProvider,
    (previous, next) => ref.invalidateSelf(),
  );

  ref.listen(
    contractListProvider,
    (previous, next) => ref.invalidateSelf(),
  );

  ref.listen(
    roomListProvider,
    (previous, next) => ref.invalidateSelf(),
  );

  ref.listen(
    tagListProvider,
    (previous, next) => ref.invalidateSelf(),
  );

  return await repo.fetchDatabaseStats();
}
