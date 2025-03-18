import 'package:openmeter/features/database_settings/model/autobackup_model.dart';
import 'package:openmeter/features/database_settings/repository/autobackup_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'autobackup_provider.g.dart';

@riverpod
class AutoBackup extends _$AutoBackup {
  @override
  AutoBackupModel build() {
    final AutoBackupRepository repo = ref.watch(autobackupRepositoryProvider);
    return repo.fetchData();
  }

  void setActiveState(bool value) {
    final AutoBackupRepository repo = ref.watch(autobackupRepositoryProvider);
    repo.saveActiveState(value);

    state = state.copyWith(isActive: value);
  }

  void setDeleteOldFiles(bool value) {
    final AutoBackupRepository repo = ref.watch(autobackupRepositoryProvider);
    repo.saveClearFilesState(value);

    state = state.copyWith(deleteOldBackups: value);
  }

  void setSelectedPath(String value) {
    final AutoBackupRepository repo = ref.watch(autobackupRepositoryProvider);
    repo.saveSelectedPath(value);

    state = state.copyWith(path: value);
  }
}
