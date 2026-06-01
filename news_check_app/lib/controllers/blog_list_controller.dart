import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/models/models.dart';

/// 使用前需确保已经登录
class BlogListController extends GetxController {
  // 替换为 BlogSimple 模型
  final RxList<BlogSimple> blogList = (<BlogSimple>[]).obs;

  // 当前是否正在加载新数据
  bool isLoading = false;

  int page = 1;
  int pageSize = 20;

  Future<void> loadMore() async {
    if (isLoading) return;
    isLoading = true;
    try {
      await _load();
    } on DioException catch (e) {
      // 可以在这里处理特定的错误逻辑
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _load() async {
    final authController = Get.find<AuthController>();
    // 确保 AuthController 初始化完成
    await authController.loadingFuture;
    final token = authController.token.value;

    final resp = await api.blogListGet(
      page: page.toString(),
      pageSize: pageSize.toString(),
      headers: {
        'Authorization': "Bearer $token"
      }
    );

    // 解析数据
    final body = resp.data as Map<String, dynamic>?;
    if (resp.statusCode != 200 || body == null) {
      return;
    }
    final data = body['data'] as Map<String, dynamic>?;
    final blogData = data?['blog_list'] as List<dynamic>? ?? [];

    final List<BlogSimple> blogSimpleList = [];
    for (final blogSimple in blogData) {
      blogSimpleList.add(BlogSimple.fromJson(blogSimple));
    }

    blogList.addAll(blogSimpleList);
    blogList.refresh();

    // 页码递增
    page++;
  }

  /// 重置列表（如在下拉刷新时使用）
  void refreshList() {
    page = 1;
    _clear();
    loadMore();
  }

  void _clear() {
    blogList.clear();
  }
}