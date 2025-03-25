import 'dart:developer';

import 'package:openmeter/shared/constant/log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'has_update.g.dart';

@riverpod
class HasUpdate extends _$HasUpdate {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    log('has update: $value', name: LogNames.databaseSettingsProvider);

    state = value;
  }
}
