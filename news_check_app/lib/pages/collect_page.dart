<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/theme/app_colors.dart';

=======
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/theme/app_colors.dart';

/// 收藏列表项结构
class CollectItem {
  final String title;
  final int objId;
  final int type;
  final String url;

  CollectItem({
    required this.title,
    required this.objId,
    required this.type,
    required this.url,
  });

  factory CollectItem.fromJson(Map<String, dynamic> json) {
    return CollectItem(
      title: json['title'] as String? ?? '',
      objId: json['objid'] as int? ?? 0,
      type: json['type'] as int? ?? 0,
      url: json['url'] as String? ?? '',
    );
  }

  bool get isNews => type == 4;
  bool get isBlog => type == 3;

  String get typeLabel => isNews ? '新闻' : (isBlog ? '博客' : '其他');
}

/// 收藏列表页 — 瀑布流展示用户收藏的新闻和博客
>>>>>>> 85892dc (feat: wire up collect page navigation in account page)
class CollectPage extends StatefulWidget {
  const CollectPage({super.key});

  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
<<<<<<< HEAD
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  bool _hasMore = true;
=======
  List<CollectItem> _items = [];
  bool _loading = true;
  bool _hasMore = true;
  bool _error = false;
>>>>>>> 85892dc (feat: wire up collect page navigation in account page)
  int _page = 1;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
    }
<<<<<<< HEAD
    if (_page == 1) setState(() => _loading = true);
=======
    if (_page == 1) {
      setState(() => _loading = true);
    }
    _error = false;
>>>>>>> 85892dc (feat: wire up collect page navigation in account page)

    try {
      final resp = await api.collectListGet(page: _page, pageSize: _pageSize);
      final body = resp.data as Map<String, dynamic>?;
<<<<<<< HEAD
      final data = body?['data'] as Map<String, dynamic>?;
      final list = data?['favoriteList'] as List<dynamic>? ?? [];

      final newItems = list.cast<Map<String, dynamic>>();
      if (refresh || _page == 1) {
        _items = newItems;
      } else {
        _items.addAll(newItems);
      }

      _hasMore = newItems.length >= _pageSize;
      if (_hasMore) _page++;
    } catch (_) {
      // Error handling
=======
      if (body == null || body['code'] != 200) {
        throw Exception('获取收藏列表失败');
      }
      final data = body['data'] as Map<String, dynamic>?;
      final list = data?['favoriteList'] as List<dynamic>? ?? [];

      final parsed =
          list.map((e) => CollectItem.fromJson(e as Map<String, dynamic>)).toList();

      if (refresh || _page == 1) {
        _items = parsed;
      } else {
        _items.addAll(parsed);
      }

      _hasMore = parsed.length >= _pageSize;
      if (_hasMore) _page++;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "登录过期，请重新登录");
      } else {
        _error = _items.isEmpty;
      }
    } catch (e) {
      _error = _items.isEmpty;
>>>>>>> 85892dc (feat: wire up collect page navigation in account page)
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

<<<<<<< HEAD
  String _typeLabel(int type) => type == 3 ? '博客' : '新闻';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("我的收藏")),
      body: RefreshIndicator(
        onRefresh: () => _loadData(refresh: true),
        displacement: 80,
        color: AppColors.primary,
        child: _items.isEmpty && !_loading
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bookmark_border, size: 64,
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
                          const SizedBox(height: 12),
                          Text("暂无收藏",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            )),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : MasonryGridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                itemCount: _items.length + (_hasMore ? 1 : 0),
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  if (index == _items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }

                  final item = _items[index];
                  final type = item['type'] as int? ?? 0;
                  final title = item['title'] as String? ?? '';
                  final objId = item['objid'] as int? ?? 0;
                  final typeLabel = _typeLabel(type);
                  final colors = isDark ? AppColors.cardGradientDarkForType(type) : AppColors.cardGradientForType(type);
                  final textColor = colors.first.computeLuminance() > 0.5
                      ? Colors.black87 : Colors.white;

                  return GestureDetector(
                    onTap: () {
                      if (type == 3) {
                        Get.to(() => BlogDetailPage(blogId: objId));
                      } else if (type == 4) {
                        Get.to(() => NewsDetailPage(newsId: objId));
                      }
                    },
                    child: Container(
                      height: title.length > 30 ? 200.0 : 160.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: textColor.withAlpha(30),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  typeLabel,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
=======
  void _onItemTap(CollectItem item) {
    if (item.isNews) {
      Get.to(() => NewsDetailPage(newsId: item.objId));
    } else if (item.isBlog) {
      Get.to(() => BlogDetailPage(blogId: item.objId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDark : AppColors.bgLight;
    final style = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
      ),
      backgroundColor: bgColor,
      body: _buildBody(style, isDark),
    );
  }

  Widget _buildBody(TextTheme style, bool isDark) {
    if (_loading && _items.isEmpty) {
      return _buildShimmerGrid(style, isDark);
    }

    if (_error && _items.isEmpty) {
      return _buildErrorState(style);
    }

    if (!_loading && _items.isEmpty) {
      return _buildEmptyState(style, isDark);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          if (scrollNotification.metrics.pixels >=
              scrollNotification.metrics.maxScrollExtent - 100) {
            if (_hasMore && !_loading) {
              _loadData();
            }
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => _loadData(refresh: true),
        displacement: 80,
        color: AppColors.primary,
        backgroundColor: Theme.of(context).cardColor,
        strokeWidth: 3,
        child: MasonryGridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          itemCount: _items.length + (_hasMore ? 1 : 0),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            if (index >= _items.length) {
              return _buildLoadingIndicator();
            }
            final item = _items[index];
            return _CollectCard(
              item: item,
              isDark: isDark,
              onTap: () => _onItemTap(item),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(TextTheme style, bool isDark) {
    return MasonryGridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: 8,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return _ShimmerCard(isDark: isDark);
      },
    );
  }

  Widget _buildErrorState(TextTheme style) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withAlpha(100)),
          const SizedBox(height: 16),
          Text(
            '加载失败',
            style: style.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请检查网络连接后重试',
            style: style.bodySmall?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withAlpha(150),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _loadData(refresh: true),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(TextTheme style, bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: isDark
                ? Colors.white38
                : Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无收藏',
            style: style.titleMedium?.copyWith(
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '浏览文章时点击收藏按钮即可添加',
            style: style.bodySmall?.copyWith(
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

/// 收藏卡片
class _CollectCard extends StatelessWidget {
  final CollectItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _CollectCard({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = isDark
        ? AppColors.cardGradientDarkForType(item.type)
        : AppColors.cardGradientForType(item.type);
    final height = item.title.length <= 25
        ? 160.0
        : item.title.length <= 40
            ? 200.0
            : 240.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 类型标签
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.typeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              // 标题
              Text(
                item.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 骨架屏卡片（加载占位）
class _ShimmerCard extends StatelessWidget {
  final bool isDark;

  const _ShimmerCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? Colors.white12 : Colors.black12;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: baseColor,
>>>>>>> 85892dc (feat: wire up collect page navigation in account page)
      ),
    );
  }
}