import '../../../modules/book_details/views/book_view_web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/buku_models.dart';
import '../controllers/book_controller.dart';

class BookView extends GetView<BookController> {
  final Result book;
  const BookView({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111F2C),
        title: const Text('Detail Buku', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.white), // Mengatur warna ikon
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF111F2C),
              height: 200,
              width: double.infinity,
              child: Hero(
                tag: book.title,
                child: const Icon(
                  Icons.book,
                  size: 100,
                  color: Colors.white54,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111F2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Penulis: ${book.author.isNotEmpty ? book.author : "Tidak diketahui"}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ranking:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111F2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Display name: ${book.ranksHistory.isNotEmpty ? book.ranksHistory.first.displayName : "Tidak diketahui"}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rank: ${book.ranksHistory.isNotEmpty ? book.ranksHistory.first.rank : "Tidak tersedia"}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111F2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description ?? "Tidak ada deskripsi",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Penerbit: ${book.publisher ?? "Tidak diketahui"}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ISBN: ${book.isbns.isNotEmpty ? book.isbns.first.isbn13 : "Tidak tersedia"}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111F2C),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Beli Buku Ini',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    onPressed: () {
                      Get.put(BookController());
                      Get.to(BookWebView());
                    },
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF111F2C),
                      side: const BorderSide(color: Color(0xFF111F2C)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Tambah ke Wishlist',
                        style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      GetSnackBar(
                        message: 'Fitur ini belum tersedia',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
