import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookController extends GetxController {
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    // Initialize the WebViewController
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Set JavaScript mode
      ..loadRequest(
          Uri.parse('https://www.barnesandnoble.com/')); // Load initial URL
  }

  // Method to get WebViewController
  WebViewController getWebViewController() {
    return webViewController;
  }
}
