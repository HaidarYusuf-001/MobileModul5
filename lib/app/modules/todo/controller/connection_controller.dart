import 'dart:io';

import 'package:belajardek/app/modules/utils/popups/snackbars.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Cek status koneksi awal
    _initializeConnectionStatus();

    // Tambahkan listener untuk memantau perubahan koneksi
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _handleConnectionChange(result);
    });
  }

  Future<void> _initializeConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();
    await _handleConnectionChange(result);
  }

  Future<void> _handleConnectionChange(List<ConnectivityResult> result) async {
    final currentResult = result.isNotEmpty ? result.first : ConnectivityResult.none;  // Safely get the first element

    if (currentResult == ConnectivityResult.none) {
      isConnected.value = false;
      TSnackbar.warningSnackBar(
        title: 'No Internet Connection',
        message: 'You are offline. Please check your connection.',
      );
    } else {
      final hasInternet = await _checkInternetConnection();
      if (hasInternet) {
        isConnected.value = true;
        TSnackbar.successSnackBar(
          title: 'Connection Restored',
          message: 'You are back online!',
        );
      } else {
        isConnected.value = false;
        TSnackbar.warningSnackBar(
          title: 'No Internet Access',
          message: 'Connected to a network but no internet access.',
        );
      }
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Hentikan listener jika tidak digunakan lagi
  }
}
