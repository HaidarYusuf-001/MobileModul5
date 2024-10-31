import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Request user permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      await _initLocalNotification();
      await _getFCMToken();
      await initPushNotification();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _getFCMToken() async {
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken'); // For debugging or testing
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Customize icon

    final InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          Get.toNamed(
            '/notification_screen',
            arguments: response.payload,
          );
        }
      },
    );
  }

  Future<void> initPushNotification() async {
    // Handle message when app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(message);
      }
    });

    // Handle message when app is in background and opened by the user
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    // Show pop-up notifications while the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        showForegroundNotification(message);
      }
    });
  }

  void showForegroundNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel ID
      'your_channel_name', // Replace with your channel name
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    _localNotificationsPlugin.show(
      message.hashCode, // Unique notification ID
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformDetails,
      payload: message.data.toString(), // Data as payload
    );
  }

  void handleMessage(RemoteMessage message) {
    Get.toNamed(
      '/notification_screen',
      arguments: message.data,
    );
  }
}
