import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../databases/bible_database.dart';
import '../models/bible_version_model.dart';

class NotificationService {
  static final AwesomeNotifications _awesomeNotifications =
      AwesomeNotifications();

  static ReceivedAction? initialAction;

  static Future<void> requestPermissions() async {
    final isAllowed = await _awesomeNotifications.isNotificationAllowed();
    if (!isAllowed) {
      await _awesomeNotifications.requestPermissionToSendNotifications();
    }

    await _initialize();
  }

  static Future<void> _initialize() async {
    await _awesomeNotifications.initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'the_word_channel',
          channelName: 'Inspiration notifications',
          channelDescription: 'Notification channel for Inspirations',
          importance: NotificationImportance.Max,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
    );
  }

  /// Schedules three daily notifications for morning, noon, and evening
  static Future<void> scheduleDailyNotifications(BibleVersion version) async {
    await _awesomeNotifications.cancelAllSchedules();

    final List<TimeOfDay> notificationTimes = [
      TimeOfDay(hour: 8, minute: 0), // Morning
      TimeOfDay(hour: 12, minute: 0), // Noon
      TimeOfDay(hour: 18, minute: 0), // Evening
    ];

    final inspirationVerses =
        await BibleDatabase(version).getInspirationVerses();

    for (int i = 0; i < notificationTimes.length; i++) {
      final notificationTime = notificationTimes[i];

      Random random = Random();

      int index = random.nextInt(inspirationVerses.length + 1);

      final verse = inspirationVerses[index];

      await _awesomeNotifications.createNotification(
        content: NotificationContent(
          id: index,
          channelKey: 'the_word_channel',
          title: "${verse.book} ${verse.chapter}:${verse.verse}",
          body: verse.text,
          notificationLayout: NotificationLayout.BigText,
          // payload: {
          //   'verse': "${verse.book} ${verse.chapter}:${verse.verse}",
          //   'text': verse.text,
          // },
        ),
        schedule: NotificationCalendar(
          hour: notificationTime.hour,
          minute: notificationTime.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
        ),
      );
    }
  }
}
