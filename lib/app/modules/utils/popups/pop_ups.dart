
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors_constant.dart';

class TPopUps {
  static void alertPopUp({
    required String title,
    required String subtitle,
    required String noText,
    required String yesText,
    required VoidCallback onNoPressed,
    required VoidCallback onYesPressed,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: TColorsConst.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TColorsConst.red50,
              ),
              padding: const EdgeInsets.all(16.0),
              child: const Icon(
                Icons.error_outline,
                color: TColorsConst.errorMain,
                size: 32.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: TColorsConst.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: TColorsConst.black,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onNoPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: TColorsConst.errorMain),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Text(
                    noText,
                    style: const TextStyle(
                      color: TColorsConst.errorMain,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: onYesPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColorsConst.blue500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Text(
                    yesText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
