import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/features/meters/service/meter_image_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_table_repository.g.dart';

class DeleteTableRepository {
  final LocalDatabase _database;
  final MeterImageService _imageService = MeterImageService();

  DeleteTableRepository(this._database);

  Future<bool> deleteTable() async {
    try {
      await _imageService.createDirectory();
      await _imageService.deleteFolder();

      await _database.deleteDB();

      return true;
    } catch (e) {
      return false;
    }
  }
}

@riverpod
DeleteTableRepository deleteTableRepository(Ref ref) {
  return DeleteTableRepository(ref.watch(localDbProvider));
}
