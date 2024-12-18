import 'package:get/get.dart';
import '../controller/connection_controller.dart';
class ConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionController>(ConnectionController(),permanent: true
    );
  }
}