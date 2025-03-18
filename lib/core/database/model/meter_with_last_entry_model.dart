import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/database/tables/entries.dart';

class MeterWithLastEntryModel {
  final MeterData meter;
  final Entries? entry;

  MeterWithLastEntryModel(this.meter, this.entry);
}
