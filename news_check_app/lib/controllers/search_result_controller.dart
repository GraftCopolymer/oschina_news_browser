import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/models/models.dart';

class SearchResultController extends GetxController {
  final RxList<NewsSimple> searchResults = <NewsSimple>[].obs;
  final RxBool isSearching = false.obs;
  String _currentQuery = '';
  String _currentCatalog = 'news';

  /// catalog 映射: "新闻" -> "news", "博客" -> "blog"
  Future<void> search(String query, String catalog) async {
    _currentQuery = query;
    _currentCatalog = catalog;
    isSearching.value = true;

    try {
      final resp = await api.searchGet(q: query, catalog: catalog);
      final body = resp.data;
      if (body is! Map || resp.statusCode != 200) {
        searchResults.clear();
        return;
      }
      final data = (body['data'] as Map<String, dynamic>?);
      final list = data?['searchlist'] as List? ?? data?['list'] as List? ?? [];

      searchResults.clear();
      for (final item in list) {
        final mapped = Map<String, dynamic>.from(item as Map);
        mapped['commentCount'] = item['replyCount'] ?? item['commentCount'] ?? 0;
        searchResults.add(NewsSimple.fromJson(mapped));
      }
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      isSearching.value = false;
    }
  }

  void clearResults() {
    searchResults.clear();
    _currentQuery = '';
    _currentCatalog = 'news';
  }

  String get currentQuery => _currentQuery;
  String get currentCatalog => _currentCatalog;
}