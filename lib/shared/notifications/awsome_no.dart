import 'package:areading/shared/components/components.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../themes/colors.dart';

class NotificationApi {
  static Future<bool> init() {
    return AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'Areading',
          channelName: 'AreadingReminder',
          channelDescription: 'Notification channel for Light Azkar',
          defaultColor: mainColor[index],
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
    );
  }

  static void notify({
    required String title,
    required String body,
    required String channelKey,
    String? image,
    bool locked = true,
    int id = 0,
    int notificationInterval = 10000,
  }) async {
    String timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: channelKey,
          title: title,
          body: body,
          criticalAlert: true,
          bigPicture: image,
          notificationLayout: NotificationLayout.BigPicture,
          wakeUpScreen: true,
          locked: locked,
          displayOnForeground: true),
      actionButtons: [
        NotificationActionButton(
            key: 'DONE', label: 'Done', buttonType: ActionButtonType.Default)
      ],
      schedule: NotificationInterval(
          interval: notificationInterval,
          preciseAlarm: true,
          timeZone: timeZone,
          allowWhileIdle: true,
          repeats: true),
    );
  }

  static void cancelNotification(int id, {bool cancelAll = false}) async {
    cancelAll
        ? await AwesomeNotifications().cancelAll()
        : await AwesomeNotifications().cancel(id);
  }

  static void goToAzkarScreen(context, Widget screen) {
    AwesomeNotifications().actionStream.listen((event) {
      navigateTo(context, PageTransitionType.bottomToTop, screen);
    });
  }
}
