class AutoBackupModel {
  final bool isActive;
  final bool deleteOldBackups;
  final String path;

  AutoBackupModel(this.isActive, this.deleteOldBackups, this.path);

  AutoBackupModel copyWith({
    bool? isActive,
    bool? deleteOldBackups,
    String? path,
  }) =>
      AutoBackupModel(
        isActive ?? this.isActive,
        deleteOldBackups ?? this.deleteOldBackups,
        path ?? this.path,
      );

  bool get backupIsPossible => isActive && path.isNotEmpty;
}
