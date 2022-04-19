import 'package:areading/shared/components/components.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

class NotificationApi {
  static void notify({
    required String title,
    required String body,
    required String channelKey,
    String? image,
    bool locked = true,
    int id = 0,
    int notificationInterval = 86400,
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
