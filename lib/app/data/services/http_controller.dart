import 'dart:convert';
import 'package:codingaja/app/data/models/buku_models.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HttpController extends GetxController {
  RxList<Result> results = RxList<Result>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await fetchArticles();
    super.onInit();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(
          'https://api.nytimes.com/svc/books/v3/lists/best-sellers/history.json?api-key=ioO2TP1NnE3V3cRS1SMUyGfwvZify295'));

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final bookResult = Buku.fromJson(json.decode(jsonData));
        results.value = bookResult.results;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred :$e');
    } finally {
      isLoading.value = false;
    }
  }
}
