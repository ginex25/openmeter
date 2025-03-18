import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'torch_repository.g.dart';

class TorchRepository {
  final SharedPreferencesWithCache _prefs;

  TorchRepository(this._prefs);

  bool getActiveTorchState() {
    return _prefs.getBool(SharedPreferencesKeys.activeTorch) ?? false;
  }

  void setActiveTorchState(bool value) {
    _prefs.setBool(SharedPreferencesKeys.activeTorch, value);
  }
}

@riverpod
TorchRepository torchRepository(Ref ref) {
  return TorchRepository(ref.watch(sharedPreferencesProvider));
}
