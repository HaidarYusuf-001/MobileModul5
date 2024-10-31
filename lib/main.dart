import 'package:codingaja/app/modules/home/views/home_view.dart';
import 'package:codingaja/app/modules/notif/notification_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';

import 'app/modules/register/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize notifications
  await FirebaseApi().initNotifications();

  // Initialize SharedPreferences
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  // Initialize AuthController
  Get.put(AuthController());

  // Delay initial route check
  String initialRoute = AppPages.INITIAL; // Default to initial route
  await Future.delayed(Duration.zero, () async {
    initialRoute = Get.find<AuthController>().isLoggedIn() ? AppPages.Home : AppPages.INITIAL;
  });

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: initialRoute,
      navigatorKey: navigatorKey,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      home: HomeView(), // Set a default home page
      routes: {
        '/notifications_screen': (context) => const NotificationPage(),
      },
    ),
  );
}
