import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/book_controller.dart';

class BookWebView extends GetView<BookController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Get the book now!",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF111F2C),
        toolbarHeight: 60.0,
      ),
      body: WebViewWidget(controller: controller.getWebViewController()),
    );
  }
}
