import 'dart:math';
import 'package:flutter/material.dart';
import 'app_color.dart';

class WidgetBackground extends StatelessWidget {
  final AppColor appColor = AppColor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                appColor.colorTertiary.withOpacity(0.96),
                const Color.fromARGB(255, 4, 22, 39),
              ],
            ),
          ),
        ),
        // Star field
      ],
    );
  }
}