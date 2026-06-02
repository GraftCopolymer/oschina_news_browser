import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/models/models.dart';

/// 使用前需确保已经登录
class BlogListController extends GetxController {
  // 替换为 BlogSimple 模型
  final RxList<BlogSimple> blogList = (<BlogSimple>[]).obs;

  // 当前是否正在加载新数据
  bool isLoading = false;
  final RxBool hasError = false.obs;

  int page = 1;
  int pageSize = 20;

  Future<void> loadMore() async {
    if (isLoading) return;
    isLoading = true;
    try {
      await _load();
      hasError.value = false;
    } on DioException catch (e) {
      hasError.value = blogList.isEmpty;
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _load() async {
    try {
      final resp = await api.blogListGet(
        page: page.toString(),
        pageSize: pageSize.toString(),
      );

      // 解析数据
      final body = resp.data as Map<String, dynamic>?;
      if (resp.statusCode != 200 || body == null) {
        hasError.value = blogList.isEmpty;
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
      hasError.value = false;
    } catch (e) {
      hasError.value = blogList.isEmpty;
      rethrow;
    }
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