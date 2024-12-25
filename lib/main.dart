import 'package:learnhub/app/modules/home/views/home_view.dart';
import 'package:learnhub/app/modules/notif/notification_page.dart';
import 'package:learnhub/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/firebase_api.dart';
import 'app/modules/home/controllers/microphone_controller.dart';
import 'app/modules/todo/controller/connection_controller.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';

import 'app/modules/register/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool allPermissionsGranted = await PermissionManager.requestAllPermissions();
  if (!allPermissionsGranted) {
    print("Some permissions are not granted. The app might not function properly.");
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  Get.put(MicrophoneController());


  // Initialize Firebase


  // Initialize notifications


  // Initialize SharedPreferences
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  // Initialize AuthController
  Get.put(AuthController());
  DependencyInjection.init();
  Get.put(ConnectionController());

  // Delay initial route check
  String initialRoute = AppPages.INITIAL; // Default to initial route
  await Future.delayed(Duration.zero, () async {
    initialRoute = Get.find<AuthController>().isSignedIn() ? AppPages.Home : AppPages.INITIAL;
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
