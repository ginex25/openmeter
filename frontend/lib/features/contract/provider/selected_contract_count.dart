import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_contract_count.g.dart';

@riverpod
class SelectedContractCount extends _$SelectedContractCount {
  @override
  int build() {
    return 0;
  }

  Future<void> setSelectedState(int value) async {
    state = value;
  }
}
