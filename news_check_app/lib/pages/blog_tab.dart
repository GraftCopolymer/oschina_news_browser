import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/blog_list_controller.dart';
import 'package:news_check_app/controllers/offline_cache_controller.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/pages/cache_management_page.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';
import 'package:news_check_app/theme/app_colors.dart';
import 'package:news_check_app/widgets/staggered_blog_card.dart';

class BlogTab extends StatefulWidget {
  const BlogTab({super.key});

  @override
  State<BlogTab> createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> with AutomaticKeepAliveClientMixin {
  final _blogListController = Get.put(BlogListController());

  @override
  void initState() {
    super.initState();
    _blogListController.loadMore().onError((e, _) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "登录过期, 请重新登录");
        } else {
          Fluttertoast.showToast(msg: "未知错误");
        }
      } else {
        Fluttertoast.showToast(msg: "未知错误");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.maxScrollExtent ==
            scrollNotification.metrics.pixels) {
          _blogListController.loadMore();
          return true;
        }
        return false;
      },
      child: Obx(() {
        if (_blogListController.blogList.isEmpty) {
          if (_blogListController.hasError.value) {
            return _buildErrorState();
          }
          return const ShimmerGrid();
        }
        return RefreshIndicator(
          onRefresh: () async {
            _blogListController.refreshList();
          },
          displacement: 80,
          color: AppColors.primary,
          backgroundColor: Theme.of(context).cardColor,
          strokeWidth: 3,
          child: MasonryGridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: _blogListController.blogList.length,
            gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final blog = _blogListController.blogList[index];
              final height = blog.title.length <= 25
                  ? 200.0
                  : blog.title.length <= 40
                      ? 250.0
                      : 280.0;
              return StaggeredBlogCard(
                blog: blog,
                height: height,
                onTap: (b) {
                  Get.to(() => BlogDetailPage(blogId: b.id))
                      ?.then((_) {
                    if (mounted) {
                      Get.find<OfflineCacheController>()
                          .refreshCachedKeys();
                    }
                  });
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64,
                color: colorScheme.onSurfaceVariant.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              "文章获取失败",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "请检查网络连接后重试",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withAlpha(150),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    _blogListController.refreshList();
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("重试"),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () => Get.to(() => const CacheManagementPage()),
                  icon: const Icon(Icons.storage, size: 18),
                  label: const Text("查看缓存"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}