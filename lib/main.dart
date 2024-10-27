import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/modules/register/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      getPages: AppPages.routes,
    ),
  );
}