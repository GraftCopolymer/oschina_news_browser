import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/models/models.dart';

/// 使用前需确保已经登录
class NewsListController extends GetxController {
  final RxList<NewsSimple> newsList = (<NewsSimple>[]).obs;
  // 当前是否正在加载新数据
  bool isLoading = false;

  int page = 1;
  int pageSize = 20;

  Future<void> loadMore() async {
    if (isLoading) return;
    isLoading = true;
    try {
      await _load();
    } on DioException catch(e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _load() async {
    final resp = await api.newsListGet(
      page: page.toString(),
      pageSize: pageSize.toString(),
    );
    // 解析数据
    final body = resp.data as Map<String, dynamic>?;
    if (resp.statusCode != 200 || body == null) {
      return;
    }
    final data = body['data'] as Map<String, dynamic>?;
    final newsData = data?['news_list'] as List<dynamic>?;
    if (newsData == null) {
      return;
    }
    final List<NewsSimple> newsSimpleList = [];
    for (final newsSimple in newsData) {
      newsSimpleList.add(NewsSimple.fromJson(newsSimple));
    }
    newsList.addAll(newsSimpleList);
    newsList.refresh();
    // 页码加 1
    page++;
  }

  void _clear() {
    newsList.clear();
  }

  void refreshList() {
    page = 1;
    _clear();
    loadMore();
  }
}