class DatabaseStatsModel {
  final String databaseSize;
  final String imageSize;
  final String fullSize;
  final int totalItemCounts;
  final List<double> itemValues;
  final int sumMeters;
  final int sumRooms;
  final int sumContracts;
  final int sumEntries;
  final int sumTags;
  final int sumImages;

  DatabaseStatsModel(
      this.databaseSize,
      this.imageSize,
      this.fullSize,
      this.totalItemCounts,
      this.itemValues,
      this.sumMeters,
      this.sumRooms,
      this.sumContracts,
      this.sumEntries,
      this.sumTags,
      this.sumImages);
}
