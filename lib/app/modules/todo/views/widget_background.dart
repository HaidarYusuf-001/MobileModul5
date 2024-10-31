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
                appColor.colorPrimary.withOpacity(0.96),
                const Color.fromARGB(255, 4, 22, 39),
              ],
            ),
          ),
        ),
        // Star field
        _buildStarField(context),
      ],
    );
  }

  Widget _buildStarField(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Random random = Random();

    return CustomPaint(
      size: size,
      painter: _StarPainter(random),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Random random;

  _StarPainter(this.random);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double radius =
          random.nextDouble() * 1 + 0.5; // Ukuran bintang lebih besar

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}