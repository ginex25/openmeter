import 'package:openmeter/core/enums/notifications_repeat_values.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/repository/reminder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_provider.g.dart';

@riverpod
class Reminder extends _$Reminder {
  @override
  ReminderModel build() {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    return repo.getReminderData();
  }

  Future<bool> setActiveState(bool value) async {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    bool hasPermission = await repo.setReminderState(value);

    if (hasPermission) {
      state = state.copyWith(isActive: value);

      repo.displayNotification(state);
    } else {
      state = state.copyWith(isActive: false);

      return false;
    }

    return true;
  }

  void setRepeatValue(RepeatValues value) {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    repo.setRepeatInterval(value);

    state = state.copyWith(repeatValues: value);

    repo.displayNotification(state);
  }

  void setMonthDay(int day) {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    repo.setMonthDay(day);

    state = state.copyWith(monthDay: day);

    repo.displayNotification(state);
  }

  void setMinuteAndHour(int minute, int hour) {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    repo.setMinute(minute);
    repo.setHour(hour);

    state = state.copyWith(minute: minute, hour: hour);

    repo.displayNotification(state);
  }

  void setWeekDay(int day) {
    final ReminderRepository repo = ref.watch(reminderRepositoryProvider);

    repo.setWeekDay(day);

    state = state.copyWith(weekDay: day);

    repo.displayNotification(state);
  }
}
