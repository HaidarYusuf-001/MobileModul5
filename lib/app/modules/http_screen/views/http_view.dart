import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/http_controller.dart';
import '../../book_details/views/book_view.dart';

class HttpView extends StatelessWidget {
  final HttpController httpController = Get.put(HttpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NYT Best Sellers !!!!!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF111F2C),
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 60.0,
        actions: [
          // Tambahkan IconButton untuk menu favorit

          // Menu hamburger jika diperlukan
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (httpController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (httpController.results.isEmpty) {
          return Center(
              child:
                  Text('Data tidak ditemukan', style: TextStyle(fontSize: 16)));
        } else {
          return ListView.builder(
            itemCount: httpController.results.length,
            itemBuilder: (context, index) {
              final result = httpController.results[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(result.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    subtitle: Text('Author: ${result.author}',
                        style: TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: Icon(
                          Icons.favorite_border), // Ganti dengan ikon bintang
                      onPressed: () {
                        // Ganti sesuai implementasi
                      },
                    ),
                    onTap: () {
                      Get.to(() => BookView(book: result));
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
