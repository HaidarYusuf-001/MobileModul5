import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  /// Meminta izin lokasi
  static Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  /// Meminta izin mikrofon
  static Future<bool> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Meminta izin kamera
  static Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Meminta izin notifikasi (untuk Android 13+)
  static Future<bool> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  /// Meminta semua izin secara berurutan
  static Future<bool> requestAllPermissions() async {
    List<Permission> permissions = [
      Permission.locationWhenInUse,
      Permission.microphone,
      Permission.camera,
      Permission.notification,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }

  /// Memeriksa status semua izin
  static Future<void> checkPermissionsStatus() async {
    Map<Permission, PermissionStatus> statuses = {
      Permission.locationWhenInUse: await Permission.locationWhenInUse.status,
      Permission.microphone: await Permission.microphone.status,
      Permission.camera: await Permission.camera.status,
      Permission.notification: await Permission.notification.status,
    };

    statuses.forEach((permission, status) {
      print('Permission: $permission, Status: $status');
    });
  }
}
