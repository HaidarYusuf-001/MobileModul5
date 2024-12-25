import 'package:get/get.dart';

class SplashController extends GetxController {
  var opacity = 0.0.obs; // Observable untuk animasi fade-in
  var scale =
      0.5.obs; // Observable untuk animasi zoom-in (mulai dari skala kecil)

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
    _navigateToHome();
  }

  void _startAnimation() async {
    // Mulai animasi dengan delay
    await Future.delayed(const Duration(milliseconds: 500)); // Tunggu sebentar
    opacity.value = 1.0; // Mulai fade-in
    scale.value = 1.0; // Mulai zoom-in
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5)); // Durasi splash screen
    Get.offNamed('/register'); // Navigasi ke halaman Register
  }
}
