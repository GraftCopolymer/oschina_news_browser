# 三个快速功能 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 实现关于页面、搜索结果展示、下拉刷新动画定制三个功能

**Architecture:** 三个功能相互独立，可并行开发。关于页面是纯静态页面；搜索结果展示新建控制器管理搜索请求，在搜索页内联显示瀑布流结果；下拉刷新增添品牌色定制。

**Tech Stack:** Flutter, GetX, flutter_staggered_grid_view

---

### Task 1: 关于页面

**Files:**
- Create: `news_check_app/lib/pages/about_page.dart`
- Modify: `news_check_app/lib/pages/account_page.dart`

- [ ] **Step 1: 创建关于页面**

`news_check_app/lib/pages/about_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_check_app/theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("关于")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // App 图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.primaryDark, AppColors.primary]
                      : [AppColors.primaryAccent, AppColors.primary],
                ),
              ),
              child: const Icon(Icons.code_rounded, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              "开发者资讯",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "v1.0.0",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "OSCHINA IT 资讯 App 是一款基于 Flutter 构建的移动端应用，"
                "集成 OSCHINA OpenAPI，提供新闻、博客等开发者资讯的浏览与搜索功能。",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            // 技术栈卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _infoTile(context, Icons.phone_android_outlined, "前端", "Flutter + GetX"),
                    const Divider(height: 1, indent: 56),
                    _infoTile(context, Icons.dns_outlined, "后端", "Python FastAPI"),
                    const Divider(height: 1, indent: 56),
                    _infoTile(context, Icons.storage_outlined, "数据源", "OSCHINA OpenAPI"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // GitHub 链接（复制到剪贴板）
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(const ClipboardData(text: "https://github.com/your-repo"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("GitHub 链接已复制")),
                );
              },
              icon: const Icon(Icons.code),
              label: const Text("GitHub"),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 账户页接入关于页面**

在 `news_check_app/lib/pages/account_page.dart` 中：

```dart
// 文件头部添加 import
import 'package:news_check_app/pages/about_page.dart';

// 找到关于 ListTile 的空回调，改为导航（约第 181 行）
_listTile(Icons.info_outline, "关于", () {
  Get.to(() => const AboutPage());
}),
```

- [ ] **Step 3: 提交**

```bash
git add news_check_app/lib/pages/about_page.dart \
       news_check_app/lib/pages/account_page.dart
git commit -m "feat: 添加关于页面"
```

---

### Task 2: 搜索结果控制器

**Files:**
- Create: `news_check_app/lib/controllers/search_result_controller.dart`

- [ ] **Step 1: 创建搜索结果控制器**

`news_check_app/lib/controllers/search_result_controller.dart`:

```dart
import 'package:get/get.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/services/api_client.dart';

class SearchResultController extends GetxController {
  final api = Get.find<ApiClient>();

  final RxList<NewsSimple> searchResults = <NewsSimple>[].obs;
  final RxBool isSearching = false.obs;
  String _currentQuery = '';
  String _currentCatalog = 'news';

  /// catalog 映射: "新闻" -> "news", "博客" -> "blog"
  Future<void> search(String query, String catalog) async {
    _currentQuery = query;
    _currentCatalog = catalog;
    isSearching.value = true;

    try {
      final resp = await api.searchGet(q: query, catalog: catalog);
      final data = resp.data['data'];
      // OSCHINA 搜索 API 返回 searchlist 数组
      final list = data['searchlist'] as List? ?? data['list'] as List? ?? [];

      searchResults.clear();
      for (final item in list) {
        final mapped = <String, dynamic>{
          'id': item['id'],
          'title': item['title'] ?? '',
          'author': item['author'] ?? '',
          'pubDate': item['pubDate'] ?? '',
          'authorid': item['authorid'] ?? 0,
          'type': item['type'] ?? 0,
          'commentCount': item['replyCount'] ?? item['commentCount'] ?? 0,
        };
        searchResults.add(NewsSimple.fromJson(mapped));
      }
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      isSearching.value = false;
    }
  }

  void clearResults() {
    searchResults.clear();
    _currentQuery = '';
  }

  String get currentQuery => _currentQuery;
  String get currentCatalog => _currentCatalog;
}
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/controllers/search_result_controller.dart
git commit -m "feat: 添加搜索结果控制器"
```

---

### Task 3: 搜索页面集成搜索结果

**Files:**
- Modify: `news_check_app/lib/pages/search_page.dart`

- [ ] **Step 1: 重写搜索页面**

注意：使用 `Get.isRegistered` 检查避免重复注册控制器，防止页面重复进入时崩溃。

```dart
// news_check_app/lib/pages/search_page.dart
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
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/pages/search_page.dart
git commit -m "feat: 搜索页面集成搜索结果瀑布流展示"
```

---

### Task 4: 品牌色下拉刷新优化

**Files:**
- Modify: `news_check_app/lib/pages/news_tab.dart`
- Modify: `news_check_app/lib/pages/blog_tab.dart`

**思路**: `RefreshIndicator` 不提供自定义 indicator Widget 的接口，直接使用其内置的 `CircularProgressIndicator` 并搭配品牌色定制即可达到清爽的下拉刷新效果。不创建额外的自定义组件文件。

- [ ] **Step 1: 修改 news_tab.dart**

文件头部添加 import:
```dart
import 'package:news_check_app/theme/app_colors.dart';
```

将 RefreshIndicator 替换为带品牌色定制的版本：

```dart
// 原代码（约第 55 行）：
return RefreshIndicator(
  onRefresh: () async {
    _newsListController.refreshList();
  },
  child: MasonryGridView.builder(

// 改为：
return RefreshIndicator(
  onRefresh: () async {
    await _newsListController.refreshList();
  },
  displacement: 80,
  color: AppColors.primary,
  backgroundColor: Theme.of(context).cardColor,
  strokeWidth: 3,
  child: MasonryGridView.builder(
```

- [ ] **Step 2: 同样修改 blog_tab.dart**

添加 `AppColors` import，将 RefreshIndicator 改为同样的品牌色定制。

- [ ] **Step 3: 提交**

```bash
git add news_check_app/lib/pages/news_tab.dart \
       news_check_app/lib/pages/blog_tab.dart
git commit -m "feat: 品牌色定制下拉刷新"
```

---

### Task 5: 更新 DEV.md

**Files:**
- Modify: `DEV.md`

- [ ] **Step 1: 在 DEV.md 中标记这三个功能为已实现**

打开 `DEV.md`，在 "项目当前功能状态" 表格中：
- 添加"关于页面"行（✅ 完成）
- 将"全局搜索"的 🟡 部分改为 ✅ 完成
- 添加"下拉刷新定制"行（✅ 完成）

同时在 "推荐开发顺序" 中搜索功能、关于页面、下拉刷新的对应项前打勾。

- [ ] **Step 2: 提交**

```bash
git add DEV.md
git commit -m "docs: 更新 DEV.md 标记已实现功能"
```

---

### 文件修改总览

| 文件 | 操作 | 说明 |
|------|------|------|
| `news_check_app/lib/pages/about_page.dart` | 新建 | 关于页面 |
| `news_check_app/lib/pages/account_page.dart` | 修改 | "关于"按钮接入导航 |
| `news_check_app/lib/controllers/search_result_controller.dart` | 新建 | 搜索请求和结果管理 |
| `news_check_app/lib/pages/search_page.dart` | 重写 | 搜索历史 + 搜索结果内嵌瀑布流 |
| `news_check_app/lib/pages/news_tab.dart` | 修改 | RefreshIndicator 品牌色定制 |
| `news_check_app/lib/pages/blog_tab.dart` | 修改 | RefreshIndicator 品牌色定制 |
| `DEV.md` | 修改 | 更新功能状态 |