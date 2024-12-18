
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../constants/colors_constant.dart';

class TSnackbar {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: TColorsConst.black.withOpacity(0.8),
          ),
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: TColorsConst.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({
    required String title,
    required String message,
    int duration = 3,
    bool isTop = false,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColorsConst.white,
      backgroundColor: TColorsConst.green500,
      snackPosition: isTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(16.0),
      icon: const Icon(Icons.check_circle_outline_rounded,
          color: TColorsConst.white),
    );
  }

  static warningSnackBar({
    required String title,
    required String message,
    bool isTop = false,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColorsConst.white,
      backgroundColor: TColorsConst.warningMain,
      snackPosition: isTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16.0),
      icon: const Icon(IconsaxPlusBold.warning_2, color: TColorsConst.white),
    );
  }

  static errorSnackBar({
    required String title,
    required String message,
    bool isTop = false,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColorsConst.white,
      backgroundColor: TColorsConst.errorMain,
      snackPosition: isTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16.0),
      icon: const Icon(IconsaxPlusBold.warning_2, color: TColorsConst.white),
    );
  }
}
