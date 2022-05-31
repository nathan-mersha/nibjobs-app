import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nibjobs/route/route.dart';
import 'package:rxdart/rxdart.dart';

import 'flutterfire.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class HLocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  static BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();

  static void initialize(BuildContext context) {
    var android = AndroidInitializationSettings('ic_launcher');
    var iOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
        ) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String? message) async {
      final routerFromMessage = message!;
      print("routerFromMessage $message");
      if (message.toLowerCase() == "job notification") {
        Navigator.of(context).pushReplacementNamed(RouteTo.HOME);
      } else if (message.toLowerCase() != "job notification") {
        Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
      }
    });
  }

  static void onDidReceiveLocalNotification(
      int id, String title, String body, String payload,
      {BuildContext? context}) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Map valueMap = json.decode(payload);

              if (valueMap != null) {
                final routerFromMessage = valueMap["notificationTag"];
                debugPrint("message.data $valueMap");
                if (routerFromMessage == "gift") {
                  Navigator.of(context, rootNavigator: true).pop();
                  makeWebCall("tel:*805*${valueMap["code"]}#");
                } else if (title.toLowerCase() != "job notification") {
                  print("title.toLowerCase()l ${title.toLowerCase()}");
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
                } else if (title.toLowerCase() == "job notification") {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.of(context)
                      .pushReplacementNamed(RouteTo.HOME);
                }
              } else {
                if (title.toLowerCase() != "job notification") {
                  print("title.toLowerCase() ${title.toLowerCase()}");
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.of(context).pushNamed(RouteTo.NOTIFICATION);
                } else if (title.toLowerCase() == "job notification") {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.of(context)
                      .pushReplacementNamed(RouteTo.HOME);
                }
              }
            },
          )
        ],
      ),
    );
  }

  static showNotification(RemoteMessage message) async {
    try {
      var android = const AndroidNotificationDetails(
          'kelemapp', 'kelemapp NAME',
          channelDescription: 'CHANNEL DESCRIPTION',
          importance: Importance.max,
          priority: Priority.high);
      var ios = IOSNotificationDetails();
      var platform = NotificationDetails(android: android, iOS: ios);
      await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          message.notification!.title,
          message.notification!.body,
          platform,
          payload: message.notification!.title.toString());
    } on Exception catch (e) {}
  }

  // on select notification action
  static Future onSelectNotification(var message, BuildContext context) {
    final routerFromMessage = message;

    return Future.value(true);
  }
}
