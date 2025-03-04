import 'package:openmeter/features/meters/model/sort_model.dart';
import 'package:openmeter/features/meters/repository/sort_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sort_provider.g.dart';

@riverpod
class SortProvider extends _$SortProvider {
  @override
  SortModel build() {
    final repo = ref.watch(sortRepositoryProvider);

    return repo.loadSortModel();
  }

  void setSort(String sort) {
    final repo = ref.watch(sortRepositoryProvider);

    repo.saveSort(sort);

    state = state.copyWith(sort: sort);
  }

  void setOrder(String order) {
    final repo = ref.watch(sortRepositoryProvider);

    repo.saveOrder(order);

    state = state.copyWith(order: order);
  }
}
