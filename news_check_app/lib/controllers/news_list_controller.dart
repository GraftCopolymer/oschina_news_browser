import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
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
    final authController = Get.find<AuthController>();
    await authController.loadingFuture;
    final token = authController.token.value;
    final resp = await api.newsListGet(
      page: page,
      pageSize: pageSize,
      headers: {
        'Authorization': "Bearer $token"
      }
    );
    // 解析数据
    final data = resp.data;
    if (resp.statusCode != 200) {
      return;
    }
    if (data == null) {
      return;
    }
    final List<NewsSimple> newsSimpleList = [];
    final newsData = data.data!.asMap['news_list'];
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
}