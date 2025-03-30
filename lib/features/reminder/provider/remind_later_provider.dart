import 'package:openmeter/features/reminder/model/remind_later.dart' as model;
import 'package:openmeter/features/reminder/repository/reminder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remind_later_provider.g.dart';

@riverpod
class RemindLater extends _$RemindLater {
  @override
  model.RemindLater build() {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    return repo.getRemindLater();
  }

  void saveRemindLater(model.RemindLater remindLater) {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    repo.setRemindLater(remindLater);

    state = remindLater;
  }
}
