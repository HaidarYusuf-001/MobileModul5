import 'dart:io';

import 'package:belajardek/app/modules/utils/popups/snackbars.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TInternetConnectionUtils {
  static Future<bool> checkConnection() async {
    final Connectivity connectivity = Connectivity();
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      TSnackbar.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection');

      return false;
    }

    // Attempt to ping a reliable external server to ensure internet connectivity
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      TSnackbar.errorSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection');
      return false;
    }
  }
}
