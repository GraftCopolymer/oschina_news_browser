import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/theme/app_colors.dart';

class CollectPage extends StatefulWidget {
  const CollectPage({super.key});

  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  bool _hasMore = true;
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
    if (_page == 1) setState(() => _loading = true);

    try {
      final resp = await api.collectListGet(page: _page, pageSize: _pageSize);
      final body = resp.data as Map<String, dynamic>?;
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
      // 错误静默处理
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
                  final colors = AppColors.gradientFromTitle(title, isDark: isDark);
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
      ),
    );
  }
}