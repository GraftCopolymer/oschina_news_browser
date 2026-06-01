import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/search_history_controller.dart';
import 'package:news_check_app/controllers/search_result_controller.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/widgets/search_history_widget.dart';
import 'package:news_check_app/widgets/staggered_news_card.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<String> _catalogs = ["新闻", "博客"];
  int _selectedCatalogIndex = 0;
  bool _hasSearched = false;

  late final SearchHistoryController _historyController;
  late final SearchResultController _resultController;

  String _catalogValue(int index) {
    return index == 0 ? 'news' : 'blog';
  }

  @override
  void initState() {
    super.initState();
    // 安全注册，防止页面重复进入时重复 put
    _historyController = Get.isRegistered<SearchHistoryController>()
        ? Get.find<SearchHistoryController>()
        : Get.put(SearchHistoryController(), permanent: true);
    _resultController = Get.isRegistered<SearchResultController>()
        ? Get.find<SearchResultController>()
        : Get.put(SearchResultController(), permanent: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    _historyController.addHistory(query);
    _resultController.search(query, _catalogValue(_selectedCatalogIndex));
    setState(() => _hasSearched = true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("搜索"),
        actions: _hasSearched
            ? [
                TextButton(
                  onPressed: () {
                    _resultController.clearResults();
                    setState(() => _hasSearched = false);
                  },
                  child: const Text("返回"),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "搜索${_catalogs[_selectedCatalogIndex]}",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _textController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _textController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withAlpha(80),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: _performSearch,
            ),
          ),
          // 目录选择
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(_catalogs.length, (i) {
                final isSelected = _selectedCatalogIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_catalogs[i]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCatalogIndex = i);
                        if (_hasSearched && _textController.text.isNotEmpty) {
                          _performSearch(_textController.text);
                        }
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _hasSearched ? _buildSearchResults() : _buildSearchHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Obx(() {
      if (_historyController.history.isEmpty) {
        return Center(
          child: Text(
            "暂无搜索记录",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        );
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text("搜索记录", style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                TextButton(
                  onPressed: () => _historyController.clearHistory(),
                  child: const Text("清除全部"),
                ),
              ],
            ),
          ),
          Expanded(
            child: SearchHistoryWidget(
              controller: _historyController,
              onHistoryClick: (content) {
                _textController.text = content;
                _performSearch(content);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (_resultController.isSearching.value) {
        return const ShimmerGrid();
      }
      if (_resultController.searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text("未找到相关结果",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        );
      }
      return MasonryGridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        itemCount: _resultController.searchResults.length,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final item = _resultController.searchResults[index];
          final height = item.title.length <= 25
              ? 200.0
              : item.title.length <= 40
                  ? 250.0
                  : 280.0;

          // 所有搜索结果用 StaggeredNewsCard 展示（type 字段决定渐变颜色）
          return StaggeredNewsCard(
            news: item,
            height: height,
            onTap: (n) {
              // 根据当前目录跳转对应详情页
              if (_resultController.currentCatalog == 'blog') {
                Get.to(() => BlogDetailPage(blogId: n.id));
              } else {
                Get.to(() => NewsDetailPage(newsId: n.id));
              }
            },
          );
        },
      );
    });
  }
}