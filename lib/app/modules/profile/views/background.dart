import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white,Color(0xFF111F2C)], // Ubah urutan warna dan dominasi warna
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.9], // Menentukan di mana warna transisi terjadi
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}

