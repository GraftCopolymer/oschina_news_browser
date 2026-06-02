import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/search_history_controller.dart';
import 'package:news_check_app/controllers/search_result_controller.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/widgets/search_history_widget.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';
import 'package:news_check_app/widgets/staggered_news_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<String> _catalogs = ["新闻", "博客"];
  final List<String> _catalogValues = ["news", "blog"];
  int _selectedCatalogIndex = 0;
  bool _hasSearched = false;

  late final SearchHistoryController _historyController;
  late final SearchResultController _resultController;

  @override
  void initState() {
    super.initState();
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
    final catalog = _catalogValues[_selectedCatalogIndex];
    _resultController.search(query, catalog);
    setState(() {
      _hasSearched = true;
    });
    _focusNode.unfocus();
  }

  void _switchCatalog(int index) {
    if (_selectedCatalogIndex == index) return;
    setState(() {
      _selectedCatalogIndex = index;
    });
    // 如果已经搜索过了，切换目录后自动用当前 query 重新搜索
    if (_hasSearched && _textController.text.isNotEmpty) {
      _performSearch(_textController.text);
    }
  }

  void _clearSearch() {
    _resultController.clearResults();
    setState(() {
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("搜索"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_hasSearched) {
              _clearSearch();
            } else {
              Get.back();
            }
          },
        ),
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
          // 目录选择 ChoiceChip
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
                        _switchCatalog(i);
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // 搜索结果 或 搜索历史
          Expanded(
            child: _hasSearched ? _buildSearchResults() : _buildSearchHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return GetBuilder<SearchHistoryController>(
      init: _historyController,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "搜索记录",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Spacer(),
                  if (controller.history.isNotEmpty)
                    TextButton(
                      onPressed: () => controller.clearHistory(),
                      child: const Text("清除全部"),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchHistoryWidget(
                  controller: controller,
                  onHistoryClick: (content) {
                    _textController.text = content;
                    _performSearch(content);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (_resultController.isSearching.value) {
        return const ShimmerGrid();
      }
      if (_resultController.searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100)),
              const SizedBox(height: 12),
              Text(
                "未找到相关结果",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          await _resultController.search(
            _resultController.currentQuery,
            _resultController.currentCatalog,
          );
        },
        displacement: 80,
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).cardColor,
        strokeWidth: 3,
        child: MasonryGridView.builder(
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
            return StaggeredNewsCard(
              news: item,
              height: height,
              onTap: (n) {
                final catalog = _resultController.currentCatalog;
                if (catalog == 'blog') {
                  Get.to(() => BlogDetailPage(blogId: n.id));
                } else {
                  Get.to(() => NewsDetailPage(newsId: n.id));
                }
              },
            );
          },
        ),
      );
    });
  }
}