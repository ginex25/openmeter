import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/entry_dto.dart';

part 'filtered_entries.g.dart';

@riverpod
List<EntryDto> filteredEntries(Ref ref) {
  return [];
}
