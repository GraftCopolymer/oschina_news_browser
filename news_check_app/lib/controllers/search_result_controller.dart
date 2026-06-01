import 'package:get/get.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/services/api_client.dart';

class SearchResultController extends GetxController {
  final api = Get.find<ApiClient>();

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
      final data = resp.data['data'];
      // OSCHINA 搜索 API 返回 searchlist 数组
      final list = data['searchlist'] as List? ?? data['list'] as List? ?? [];

      searchResults.clear();
      for (final item in list) {
        final mapped = <String, dynamic>{
          'id': item['id'],
          'title': item['title'] ?? '',
          'author': item['author'] ?? '',
          'pubDate': item['pubDate'] ?? '',
          'authorid': item['authorid'] ?? 0,
          'type': item['type'] ?? 0,
          'commentCount': item['replyCount'] ?? item['commentCount'] ?? 0,
        };
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
  }

  String get currentQuery => _currentQuery;
  String get currentCatalog => _currentCatalog;
}