import 'package:openmeter/core/enums/notifications_repeat_values.dart';

class ReminderModel {
  final bool isActive;
  final RepeatValues repeatValues;
  final int weekDay;
  final int minute;
  final int hour;
  final int monthDay;

  ReminderModel(this.isActive, this.repeatValues, this.weekDay, this.minute,
      this.hour, this.monthDay);

  ReminderModel copyWith(
          {bool? isActive,
          RepeatValues? repeatValues,
          int? weekDay,
          int? minute,
          int? hour,
          int? monthDay}) =>
      ReminderModel(
          isActive ?? this.isActive,
          repeatValues ?? this.repeatValues,
          weekDay ?? this.weekDay,
          minute ?? this.minute,
          hour ?? this.hour,
          monthDay ?? this.monthDay);
}
