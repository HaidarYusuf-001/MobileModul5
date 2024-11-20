import 'package:codingaja/app/modules/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../views/login_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  final SharedPreferences _prefs = Get.find<SharedPreferences>();

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _prefs.setBool('isSignedIn', true);
        Get.offAll(LoginPage());
      }
    });
  }

  void logout() async {
    await _auth.signOut();
    _prefs.setBool('isSignedIn', false);
    Get.offAll(LoginPage());
  }

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.green);
    } on FirebaseAuthException catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
  bool isSignedIn() {
    return _prefs.getBool('isSignedIn') ?? false;
  }
}