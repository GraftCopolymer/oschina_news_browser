import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/news_list_controller.dart';
import 'package:news_check_app/controllers/offline_cache_controller.dart';
import 'package:news_check_app/pages/cache_management_page.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';
import 'package:news_check_app/theme/app_colors.dart';
import 'package:news_check_app/widgets/staggered_news_card.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with AutomaticKeepAliveClientMixin {
  final _newsListController = Get.put(NewsListController());
  late final Worker _cacheWorker;

  @override
  void initState() {
    super.initState();
    _newsListController.loadMore().onError((e, _) {
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
    // 监听缓存变化，强制列表重建使卡片"已缓存"标记及时更新
    _cacheWorker = ever(
      Get.find<OfflineCacheController>().cachedKeys,
      (_) => _newsListController.newsList.refresh(),
    );
  }

  @override
  void dispose() {
    _cacheWorker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.maxScrollExtent ==
            scrollNotification.metrics.pixels) {
          _newsListController.loadMore();
          return true;
        }
        return false;
      },
      child: Obx(() {
        if (_newsListController.newsList.isEmpty) {
          if (_newsListController.hasError.value) {
            return _buildErrorState();
          }
          return const ShimmerGrid();
        }
        return RefreshIndicator(
          onRefresh: () async {
            _newsListController.refreshList();
          },
          displacement: 80,
          color: AppColors.primary,
          backgroundColor: Theme.of(context).cardColor,
          strokeWidth: 3,
          child: MasonryGridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: _newsListController.newsList.length,
            gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final news = _newsListController.newsList[index];
              // 根据标题长度决定高度
              final height = news.title.length <= 25
                  ? 200.0
                  : news.title.length <= 40
                      ? 250.0
                      : 280.0;
              return StaggeredNewsCard(
                news: news,
                height: height,
                onTap: (n) {
                  Get.to(() => NewsDetailPage(newsId: n.id))
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
                    _newsListController.refreshList();
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