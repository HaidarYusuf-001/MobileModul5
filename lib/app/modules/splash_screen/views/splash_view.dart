import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circle2ScaleAnimation;
  late Animation<double> _circle3ScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi lingkaran
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Durasi total animasi
    )..repeat(
        reverse: true, // Animasi berulang dengan efek "membesar-mengecil"
      );

    _circle2ScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _circle3ScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigasi ke halaman berikutnya setelah durasi animasi
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context, '/register'); // Ganti dengan route sesuai aplikasi
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(2, 45, 109, 1), // Background biru tua
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circle lapisan ke-3 (putih)
            AnimatedBuilder(
              animation: _circle3ScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _circle3ScaleAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                          .withOpacity(0.4), // Warna putih transparan
                    ),
                  ),
                );
              },
            ),

            // Circle lapisan ke-2 (abu-abu)
            AnimatedBuilder(
              animation: _circle2ScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _circle2ScaleAnimation.value,
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.6), // Warna abu-abu transparan
                    ),
                  ),
                );
              },
            ),

            // Circle logo (utama)
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(
                    255, 3, 90, 145), // Background lingkaran logo
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logoapp.png', // Ganti dengan path logo kamu
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
