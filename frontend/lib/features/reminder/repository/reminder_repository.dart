import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/features/reminder/model/notifications_repeat_values.dart';
import 'package:openmeter/features/reminder/model/remind_later.dart';
import 'package:openmeter/features/reminder/model/reminder_model.dart';
import 'package:openmeter/features/reminder/service/local_notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'reminder_repository.g.dart';

class ReminderRepository {
  final SharedPreferencesWithCache _prefs;
  final LocalNotificationService _localNotificationService;

  ReminderRepository(this._prefs, this._localNotificationService);

  bool getReminderState() {
    return _prefs.getBool(SharedPreferencesKeys.reminderState) ?? false;
  }

  Future<bool> setReminderState(bool value) async {
    _prefs.setBool(SharedPreferencesKeys.reminderState, value);

    bool firstOn =
        _prefs.getBool(SharedPreferencesKeys.reminderFirstOn) ?? true;

    if (firstOn) {
      final bool permissionAllowed =
          await _localNotificationService.requestPermission();

      if (permissionAllowed == false) {
        _prefs.setBool(SharedPreferencesKeys.reminderState, false);
        _prefs.setBool(SharedPreferencesKeys.reminderFirstOn, true);
        return false;
      }

      _prefs.setBool(SharedPreferencesKeys.reminderFirstOn, false);
    }

    if (!value) {
      _localNotificationService.removeReminder();
    }

    return true;
  }

  RepeatValues getRepeatInterval() {
    final repeatVal =
        _prefs.getString(SharedPreferencesKeys.reminderRepeatInterval);

    switch (repeatVal) {
      case 'daily':
        return RepeatValues.daily;
      case 'weekly':
        return RepeatValues.weekly;
      default:
        return RepeatValues.monthly;
    }
  }

  void setRepeatInterval(RepeatValues value) {
    _prefs.setString(SharedPreferencesKeys.reminderRepeatInterval, value.name);
  }

  void setMonthDay(int day) {
    _prefs.setInt(SharedPreferencesKeys.reminderDay, day);
  }

  void setHour(int hour) {
    _prefs.setInt(SharedPreferencesKeys.reminderHour, hour);
  }

  void setMinute(int minute) {
    _prefs.setInt(SharedPreferencesKeys.reminderMinute, minute);
  }

  void setWeekDay(int weekDay) {
    _prefs.setInt(SharedPreferencesKeys.reminderWeekDay, weekDay);
  }

  ReminderModel getReminderData() {
    final now = DateTime.now();

    final reminderValue = getRepeatInterval();
    final bool reminderState = getReminderState();
    final int monthDay = _prefs.getInt(SharedPreferencesKeys.reminderDay) ?? 1;
    final int hour =
        _prefs.getInt(SharedPreferencesKeys.reminderHour) ?? now.hour;
    final int minute =
        _prefs.getInt(SharedPreferencesKeys.reminderMinute) ?? now.minute;
    final int weekDay =
        _prefs.getInt(SharedPreferencesKeys.reminderWeekDay) ?? 0;

    return ReminderModel(
        reminderState, reminderValue, weekDay, minute, hour, monthDay);
  }

  void displayNotification(ReminderModel reminder) async {
    _localNotificationService.setRemindLater(getRemindLater());

    switch (reminder.repeatValues) {
      case RepeatValues.daily:
        _localNotificationService.dailyReminder(reminder.hour, reminder.minute);
        break;
      case RepeatValues.weekly:
        _localNotificationService.weeklyReminder(
            reminder.hour, reminder.minute, reminder.weekDay + 1);
        break;
      default:
        _localNotificationService.monthlyReminder(
            reminder.hour, reminder.minute, reminder.monthDay);
    }
  }

  void testNotification() async {
    _localNotificationService.testNotification();
  }

  void setRemindLater(RemindLater remindLater) {
    _prefs.setString(SharedPreferencesKeys.reminderRemindLater,
        jsonEncode(remindLater.toJson));

    displayNotification(getReminderData());
  }

  RemindLater getRemindLater() {
    String? remindLaterString =
        _prefs.getString(SharedPreferencesKeys.reminderRemindLater);

    if (remindLaterString == null) {
      return RemindLater.initialize();
    }

    return RemindLater.fromJson(jsonDecode(remindLaterString));
  }
}

@riverpod
ReminderRepository reminderRepository(Ref ref) {
  return ReminderRepository(
    ref.watch(sharedPreferencesProvider),
    ref.watch(localNotificationServiceProvider),
  );
}
