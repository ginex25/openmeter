import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/features/reminder/exception/no_permission.dart';
import 'package:openmeter/features/reminder/model/remind_later.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../shared/constant/log.dart';

part 'local_notification_service.g.dart';

const String actionRemindMeLaterId = 'remind_me_later';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  final String _notificationTitle = 'Ableseerinnerung';
  final String _notificationBody =
      'Heute sollen die Zähler wieder abgelesen werden!';

  RemindLater? _remindLater;

  void setRemindLater(RemindLater value) {
    _remindLater = value;
  }

  Future<void> initialize() async {
    await _initTimeZone();
    await _initLocalNotification();
  }

  Future<void> _initTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
  }

  Future<void> _initLocalNotification() async {
    const androidSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher_monochrome');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSetting,
    );

    await _localNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /*
    request notification permission
     for android 13 and higher
   */
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final allowed = await _localNotificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      if (allowed == null || allowed == false) {
        return false;
      }

      final exactAllowed = await _localNotificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();

      return exactAllowed ?? false;
    }

    return false;
  }

  AndroidNotificationDetails get _androidNotificationDetails =>
      const AndroidNotificationDetails(
        'reminder',
        'Ableseerinnerung',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_stat_logo',
        actions: [
          AndroidNotificationAction(actionRemindMeLaterId, 'Später erinnern'),
        ],
      );

  NotificationDetails get _notificationDetails =>
      NotificationDetails(android: _androidNotificationDetails);

  tz.TZDateTime _convertTime(int hour, int minute, {int? day}) {
    final tz.TZDateTime timeNow = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      timeNow.year,
      timeNow.month,
      day ?? timeNow.day,
      hour,
      minute,
    );

    log('Set schedule date: $scheduleDate', name: LogNames.readingReminder);

    return scheduleDate.isBefore(timeNow)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  void dailyReminder(int hour, int minute) async {
    bool hasPermission = await requestPermission();

    if (!hasPermission) {
      throw NoPermissionException();
    }

    final scheduleTime = _convertTime(hour, minute);

    await _localNotificationPlugin.zonedSchedule(
      0,
      _notificationTitle,
      _notificationBody,
      scheduleTime,
      _notificationDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: _remindLater != null ? jsonEncode(_remindLater!.toJson) : null,
    );
  }

  tz.TZDateTime _convertTimeWeekly(int hour, int minute, int day) {
    tz.TZDateTime scheduleDate = _convertTime(hour, minute);

    while (!(scheduleDate.weekday == day)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    log('Set weekly schedule date: $scheduleDate',
        name: LogNames.readingReminder);

    return scheduleDate;
  }

  void weeklyReminder(int hour, int minute, int day) async {
    bool hasPermission = await requestPermission();

    if (!hasPermission) {
      throw NoPermissionException();
    }

    await _localNotificationPlugin.zonedSchedule(
      0,
      _notificationTitle,
      _notificationBody,
      _convertTimeWeekly(hour, minute, day),
      _notificationDetails,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: _remindLater != null ? jsonEncode(_remindLater!.toJson) : null,
    );
  }

  tz.TZDateTime _convertTimeMonthly(int hour, int minute, int day) {
    tz.TZDateTime scheduleDate = _convertTime(hour, minute);

    while (scheduleDate.day != day) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    log('Set monthly schedule date: $scheduleDate',
        name: LogNames.readingReminder);

    return scheduleDate;
  }

  void monthlyReminder(int hour, int minute, int day) async {
    bool hasPermission = await requestPermission();

    if (!hasPermission) {
      throw NoPermissionException();
    }

    await _localNotificationPlugin.zonedSchedule(
      0,
      _notificationTitle,
      _notificationBody,
      _convertTimeMonthly(hour, minute, day),
      _notificationDetails,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: _remindLater != null ? jsonEncode(_remindLater!.toJson) : null,
    );
  }

  void testNotification() async {
    await _localNotificationPlugin.show(
      1,
      'Test Ableseerinnerung',
      'Dies ist ein Test!',
      _notificationDetails,
      payload: _remindLater != null ? jsonEncode(_remindLater!.toJson) : null,
    );
  }

  void removeReminder() {
    _localNotificationPlugin.cancelAll();
  }

  Future<void> _exactlyReminder(tz.TZDateTime scheduleTime) async {
    log('Set exactly reminder schedule date: $scheduleTime',
        name: LogNames.readingReminder);

    await _localNotificationPlugin.zonedSchedule(
      0,
      _notificationTitle,
      _notificationBody,
      scheduleTime,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: _remindLater != null ? jsonEncode(_remindLater!.toJson) : null,
    );
  }

  Future<void> _remindLaterDay() async {
    tz.TZDateTime timeNow = tz.TZDateTime.now(tz.local);

    timeNow = timeNow.add(Duration(days: _remindLater!.time));

    await _exactlyReminder(timeNow);
  }

  Future<void> _remindLaterMinute() async {
    tz.TZDateTime timeNow = tz.TZDateTime.now(tz.local);

    timeNow = timeNow.add(Duration(minutes: _remindLater!.time));

    await _exactlyReminder(timeNow);
  }

  Future<void> _remindLaterHour() async {
    tz.TZDateTime timeNow = tz.TZDateTime.now(tz.local);

    timeNow = timeNow.add(Duration(hours: _remindLater!.time));

    await _exactlyReminder(timeNow);
  }

  void remindLater() async {
    if (_remindLater == null) {
      throw NullValueException();
    }

    switch (_remindLater!.type) {
      case RemindLaterType.day:
        await _remindLaterDay();
        break;
      case RemindLaterType.hour:
        await _remindLaterHour();
        break;
      case RemindLaterType.minute:
        await _remindLaterMinute();
        break;
    }
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  if ((notificationResponse.actionId ?? '') == actionRemindMeLaterId) {
    final RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;

    if (rootIsolateToken == null) {
      return;
    }

    final service = LocalNotificationService();
    service.initialize();

    if (notificationResponse.payload == null) {
      throw NullValueException();
    }

    RemindLater remindLater =
        RemindLater.fromJson(jsonDecode(notificationResponse.payload!));

    service.setRemindLater(remindLater);

    service.remindLater();
  }
}

@riverpod
LocalNotificationService localNotificationService(Ref ref) {
  throw UnimplementedError();
}
