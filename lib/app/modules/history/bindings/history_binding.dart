import 'package:get/get.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBinding>(
      () => HistoryBinding(),
    );
  }
}
