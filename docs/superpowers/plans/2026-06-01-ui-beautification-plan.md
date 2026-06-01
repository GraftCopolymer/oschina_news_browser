# UI 美化实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 OSCHINA IT 资讯 Flutter App 应用完整的 UI 美化方案 — 自定义主题、瀑布流卡片布局、登录页/个人中心/搜索页改造、骨架屏和动效。

**Architecture:** 所有改动在 Flutter 前端，不影响后端。新建 `lib/theme/` 放置主题系统，新建 `lib/widgets/` 放置瀑布流卡片和骨架屏组件。修改现有页面文件以替换布局和样式。

**Tech Stack:** Flutter, GetX, Dio, flutter_staggered_grid_view, flutter_markdown_plus, webview_flutter

---

### Task 1: 添加 flutter_staggered_grid_view 依赖

**Files:**
- Modify: `news_check_app/pubspec.yaml`

- [ ] **Step 1: 在 pubspec.yaml 的 dependencies 中添加 flutter_staggered_grid_view**

在 `dependencies:` 块中，`flutter_markdown_plus` 之后添加一行：

```yaml
  flutter_staggered_grid_view: ^0.7.0
```

- [ ] **Step 2: 运行 flutter pub get**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter pub get`
Expected: 成功解析依赖，无报错

- [ ] **Step 3: 提交**

```bash
git add news_check_app/pubspec.yaml news_check_app/pubspec.lock
git commit -m "chore: 添加 flutter_staggered_grid_view 依赖"
```

---

### Task 2: 创建颜色系统 (app_colors.dart)

**Files:**
- Create: `news_check_app/lib/theme/app_colors.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';

/// 青蓝主色调
class AppColors {
  AppColors._();

  // ── 主色 ──
  static const Color primary = Color(0xFF0D9488);      // Teal-600
  static const Color primaryDark = Color(0xFF0F766E);   // Teal-700
  static const Color primaryAccent = Color(0xFF14B8A6); // Teal-500
  static const Color primaryLight = Color(0xFFCCFBF1);  // Teal-100

  // ── 辅助色 ──
  static const Color accentOrange = Color(0xFFF59E0B);

  // ── 卡片背景渐变 ──
  static const List<Color> gradientTeal = [Color(0xFF14B8A6), Color(0xFF0D9488)];
  static const List<Color> gradientPurple = [Color(0xFFA855F7), Color(0xFF7C3AED)];
  static const List<Color> gradientAmber = [Color(0xFFFBBF24), Color(0xFFF59E0B)];
  static const List<Color> gradientGray = [Color(0xFFE2E8F0), Color(0xFFCBD5E1)];

  // ── 深色模式卡片渐变 ──
  static const List<Color> gradientTealDark = [Color(0xFF0F766E), Color(0xFF0D9488)];
  static const List<Color> gradientPurpleDark = [Color(0xFF6B21A8), Color(0xFF7C3AED)];
  static const List<Color> gradientAmberDark = [Color(0xFFB45309), Color(0xFFD97706)];
  static const List<Color> gradientGrayDark = [Color(0xFF334155), Color(0xFF475569)];

  /// 根据 type 返回亮色卡片渐变
  static List<Color> cardGradientForType(int type) {
    const gradients = [
      gradientTeal,    // type=0 链接新闻
      gradientPurple,  // type=1 软件推荐
      gradientAmber,   // type=2 讨论区
      gradientTeal,    // type=3 博客
      gradientGray,    // type=4 普通新闻
      gradientPurple,  // type=5 (预留)
      gradientAmber,   // type=6 (预留)
      gradientTeal,    // type=7 翻译文章
    ];
    return gradients[type.clamp(0, gradients.length - 1)];
  }

  /// 根据 type 返回暗色卡片渐变
  static List<Color> cardGradientDarkForType(int type) {
    const gradients = [
      gradientTealDark,
      gradientPurpleDark,
      gradientAmberDark,
      gradientTealDark,
      gradientGrayDark,
      gradientPurpleDark,
      gradientAmberDark,
      gradientTealDark,
    ];
    return gradients[type.clamp(0, gradients.length - 1)];
  }

  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textDark = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
}
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/theme/app_colors.dart
git commit -m "feat(theme): 添加颜色系统 app_colors.dart"
```

---

### Task 3: 创建自定义 ThemeData (app_theme.dart)

**Files:**
- Create: `news_check_app/lib/theme/app_theme.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';
import 'package:news_check_app/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.bgLight,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.textSecondary.withAlpha(40),
      thickness: 0.5,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.bgDark,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.textSecondary.withAlpha(40),
      thickness: 0.5,
    ),
  );
}
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/theme/app_theme.dart
git commit -m "feat(theme): 创建自定义 ThemeData 工厂 app_theme.dart"
```

---

### Task 4: 集成自定义主题到 main.dart

**Files:**
- Modify: `news_check_app/lib/main.dart`

- [ ] **Step 1: 修改 main.dart**

替换 `ThemeData.light()` 和 `ThemeData.dark()` 为自定义主题：

```dart
import 'package:news_check_app/theme/app_theme.dart'; // 新增

// 在 MyApp build 中:
theme: AppTheme.light,
darkTheme: AppTheme.dark,
```

完整修改：在 import 部分新增 `import 'package:news_check_app/theme/app_theme.dart';`，然后将 `theme: ThemeData.light()` 改为 `theme: AppTheme.light`，`darkTheme: ThemeData.dark()` 改为 `darkTheme: AppTheme.dark`。

同时更新 BottomNav 图标大小和样式：在 AppFrame 中，将图标大小从 `size: 40` 改为 `size: 28`，并在底部新增文字标签：

```dart
MyNavigationBarItem(
  icon: Icon(Icons.home_outlined, size: 28),
  activeIcon: Icon(Icons.home, size: 28),
  label: "首页",
),
MyNavigationBarItem(
  icon: Icon(Icons.search_outlined, size: 28),
  activeIcon: Icon(Icons.search, size: 28),
  label: "搜索",
),
MyNavigationBarItem(
  icon: Icon(Icons.account_circle_outlined, size: 28),
  activeIcon: Icon(Icons.account_circle_rounded, size: 28),
  label: "我的",
),
```

以及为 MyNavigationBarItem 添加 `label` 字段。

- [ ] **Step 2: 运行 flutter analyze 验证无语法错误**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 仅保留预存在的 warning，无 errors

- [ ] **Step 3: 提交**

```bash
git add news_check_app/lib/main.dart
git commit -m "feat(theme): 集成自定义主题到 main.dart，优化底部导航图标"
```

---

### Task 5: 创建 Shimmer 骨架屏组件

**Files:**
- Create: `news_check_app/lib/widgets/shimmer_loading.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';

/// Shimmer 骨架屏动画容器
class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ?? (isDark ? Colors.grey.shade800 : Colors.grey.shade300);
    final highlight = widget.highlightColor ?? (isDark ? Colors.grey.shade700 : Colors.grey.shade100);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// 单卡片骨架屏（用于详情页加载）
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerWidget(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题占位
            _ShimmerBlock(width: double.infinity, height: 24),
            SizedBox(height: 12),
            // 作者/日期行
            Row(
              children: [
                _ShimmerBlock(width: 80, height: 14),
                SizedBox(width: 12),
                _ShimmerBlock(width: 100, height: 14),
              ],
            ),
            SizedBox(height: 16),
            // 正文占位 x3
            _ShimmerBlock(width: double.infinity, height: 14),
            SizedBox(height: 8),
            _ShimmerBlock(width: double.infinity, height: 14),
            SizedBox(height: 8),
            _ShimmerBlock(width: 200, height: 14),
          ],
        ),
      ),
    );
  }
}

/// 双列 Grid 骨架屏（用于瀑布流列表加载）
class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _gridColumn(280)),
          const SizedBox(width: 12),
          Expanded(child: _gridColumn(200)),
        ],
      ),
    );
  }

  Widget _gridColumn(double height) {
    return ShimmerWidget(
      child: Column(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: height - 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
```

- [ ] **Step 2: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 3: 提交**

```bash
git add news_check_app/lib/widgets/shimmer_loading.dart
git commit -m "feat(ui): 创建 Shimmer 骨架屏组件"
```

---

### Task 6: 创建首页自定义 Header

**Files:**
- Create: `news_check_app/lib/widgets/home_header.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/pages/search_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 12,
        bottom: 4,
      ),
      child: Row(
        children: [
          Text(
            "开发者资讯",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.to(() => const SearchPage()),
            icon: const Icon(Icons.search),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/widgets/home_header.dart
git commit -m "feat(ui): 创建首页自定义 Header 组件"
```

---

### Task 7: 创建新闻瀑布流卡片

**Files:**
- Create: `news_check_app/lib/widgets/staggered_news_card.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/theme/app_colors.dart';

/// 新闻类型映射为中文标签
String _newsTypeLabel(int type) {
  switch (type) {
    case 0: return '链接';
    case 1: return '软件';
    case 2: return '讨论';
    case 3: return '博客';
    case 4: return '新闻';
    case 7: return '翻译';
    default: return '其他';
  }
}

class StaggeredNewsCard extends StatelessWidget {
  const StaggeredNewsCard({
    super.key,
    required this.news,
    this.onTap,
    this.height,
  });

  final NewsSimple news;
  final void Function(NewsSimple news)? onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.cardGradientDarkForType(news.type)
        : AppColors.cardGradientForType(news.type);

    return GestureDetector(
      onTap: () => onTap?.call(news),
      child: Container(
        height: height ?? 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.last.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 类型标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _newsTypeLabel(news.type),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 标题
            Expanded(
              child: Text(
                news.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 底部信息
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 12, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  '${news.commentCount}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  news.author,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              news.pubDate,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/widgets/staggered_news_card.dart
git commit -m "feat(ui): 创建新闻瀑布流卡片组件"
```

---

### Task 8: 创建博客瀑布流卡片

**Files:**
- Create: `news_check_app/lib/widgets/staggered_blog_card.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/theme/app_colors.dart';

/// 博客类型映射（1=原创, 4=转载）
String _blogTypeLabel(int type) {
  return type == 1 ? '原创' : '转载';
}

class StaggeredBlogCard extends StatelessWidget {
  const StaggeredBlogCard({
    super.key,
    required this.blog,
    this.onTap,
    this.height,
  });

  final BlogSimple blog;
  final void Function(BlogSimple blog)? onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.cardGradientDarkForType(blog.type)
        : AppColors.cardGradientForType(blog.type);

    return GestureDetector(
      onTap: () => onTap?.call(blog),
      child: Container(
        height: height ?? 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.last.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 类型标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _blogTypeLabel(blog.type),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 标题
            Expanded(
              child: Text(
                blog.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 底部信息
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 12, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  '${blog.commentCount}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  blog.author,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              blog.pubDate,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/widgets/staggered_blog_card.dart
git commit -m "feat(ui): 创建博客瀑布流卡片组件"
```

---

### Task 9: 重构 HomePage — 自定义 Header + TabBar 优化

**Files:**
- Modify: `news_check_app/lib/pages/home_page.dart`

- [ ] **Step 1: 重写 home_page.dart**

去掉空白 AppBar，改用自定义 Header + 优化 TabBar：

```dart
import 'package:flutter/material.dart';
import 'package:news_check_app/pages/blog_tab.dart';
import 'package:news_check_app/pages/news_tab.dart';
import 'package:news_check_app/widgets/home_header.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _tabPages = const [NewsTab(), BlogTab()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(60),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: colorScheme.onSurface.withAlpha(150),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              tabs: const [
                Tab(text: "新闻"),
                Tab(text: "博客"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(controller: _tabController, children: _tabPages),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add news_check_app/lib/pages/home_page.dart
git commit -m "feat(ui): 重构 HomePage — 自定义 Header + 圆角 TabBar"
```

---

### Task 10: 改造 NewsTab — ListView → MasonryGridView

**Files:**
- Modify: `news_check_app/lib/pages/news_tab.dart`
- Delete (opt): `news_check_app/lib/widgets/news_simple_card.dart` (不再使用)

- [ ] **Step 1: 重写 news_tab.dart**

```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/news_list_controller.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';
import 'package:news_check_app/widgets/staggered_news_card.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with AutomaticKeepAliveClientMixin {
  final _newsListController = Get.put(NewsListController());

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
          return const ShimmerGrid();
        }
        return RefreshIndicator(
          onRefresh: () async {
            _newsListController.refreshList();
          },
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
              final height = news.title.length <= 25 ? 200.0
                  : news.title.length <= 40 ? 250.0
                  : 280.0;
              return StaggeredNewsCard(
                news: news,
                height: height,
                onTap: (n) {
                  Get.to(() => NewsDetailPage(newsId: n.id));
                },
              );
            },
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
```

- [ ] **Step 2: 清理不再使用的旧卡片**

可选删除 `news_check_app/lib/widgets/news_simple_card.dart`（如果其他地方没有引用它）。
确认引用：`grep -r "NewsSimpleCard" news_check_app/lib/` 应该只返回 news_tab.dart — 但 news_tab.dart 已不再引用。
如果确认无引用，删除该文件。

- [ ] **Step 3: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 4: 提交**

```bash
git add news_check_app/lib/pages/news_tab.dart
git add news_check_app/lib/widgets/news_simple_card.dart  # 如果删除了
git commit -m "feat(ui): NewsTab 改用 MasonryGridView 瀑布流布局"
```

---

### Task 11: 改造 BlogTab — ListView → MasonryGridView

**Files:**
- Modify: `news_check_app/lib/pages/blog_tab.dart`
- Delete (opt): `news_check_app/lib/widgets/blog_simple_card.dart` (不再使用)

- [ ] **Step 1: 重写 blog_tab.dart**

```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/blog_list_controller.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';
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
          return const ShimmerGrid();
        }
        return RefreshIndicator(
          onRefresh: () async {
            _blogListController.refreshList();
          },
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
              final height = blog.title.length <= 25 ? 200.0
                  : blog.title.length <= 40 ? 250.0
                  : 280.0;
              return StaggeredBlogCard(
                blog: blog,
                height: height,
                onTap: (b) {
                  Get.to(() => BlogDetailPage(blogId: b.id));
                },
              );
            },
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
```

- [ ] **Step 2: 确认 `blog_simple_card.dart` 无引用后删除**

Run: `grep -r "BlogSimpleCard" news_check_app/lib/`
如果只出现在 blog_tab.dart 且 blog_tab.dart 已不再引用，则删除该文件。

- [ ] **Step 3: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 4: 提交**

```bash
git add news_check_app/lib/pages/blog_tab.dart
git add news_check_app/lib/widgets/blog_simple_card.dart  # 如果删除了
git commit -m "feat(ui): BlogTab 改用 MasonryGridView 瀑布流布局"
```

---

### Task 12: 改造登录页

**Files:**
- Modify: `news_check_app/lib/pages/login_page.dart`

- [ ] **Step 1: 重写登录页**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/pages/oschina_login_page.dart';
import 'package:news_check_app/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _logoFadeIn;
  late final Animation<Offset> _buttonSlideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _buttonSlideUp = Tween<Offset>(
      begin: const Offset(0, 40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF1E3A5F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo 和品牌文字
              FadeTransition(
                opacity: _logoFadeIn,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/oschina_logo.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "开发者资讯",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "发现最新的技术资讯",
                      style: TextStyle(
                        color: Colors.white.withAlpha(153),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              // 登录按钮
              SlideTransition(
                position: _buttonSlideUp,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => OschinaLoginPage(
                          onLoginSuccess: (token) {
                            Get.back();
                            Get.back();
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "使用 OSCHINA 登录",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "使用 OSCHINA 账号一键登录",
                style: TextStyle(
                  color: Colors.white.withAlpha(128),
                  fontSize: 13,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 3: 提交**

```bash
git add news_check_app/lib/pages/login_page.dart
git commit -m "feat(ui): 改造登录页 — 渐变背景 + 动画 + 品牌感"
```

---

### Task 13: 改造个人中心页

**Files:**
- Modify: `news_check_app/lib/pages/account_page.dart`

- [ ] **Step 1: 重写 account_page.dart**

```dart
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/pages/login_page.dart';
import 'package:news_check_app/pages/settings_page.dart';
import 'package:news_check_app/theme/app_colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的账户"),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const SettingsPage()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Obx(() {
        if (!_authController.isLoggedIn.value) {
          return _buildNotLoggedIn();
        }
        return _buildLoggedIn();
      }),
    );
  }

  Widget _buildNotLoggedIn() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF1E3A5F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/oschina_logo.png",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "尚未登录",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const LoginPage()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "去登录",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedIn() {
    final userInfo = _authController.userInfo.value;
    return SingleChildScrollView(
      child: Column(
        children: [
          // 背景横幅 + 头像
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF1E3A5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 头像
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      userInfo.avatar,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userInfo.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userInfo.email,
                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // 功能列表
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _listTile(Icons.star_border, "我的收藏", () {}),
                  const Divider(height: 1, indent: 56),
                  _listTile(Icons.palette_outlined, "主题设置", () {
                    Get.to(() => const SettingsPage());
                  }),
                  const Divider(height: 1, indent: 56),
                  _listTile(Icons.info_outline, "关于", () {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 退出登录
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () async {
                  await _authController.logout();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "退出登录",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _listTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
```

- [ ] **Step 2: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 3: 提交**

```bash
git add news_check_app/lib/pages/account_page.dart
git commit -m "feat(ui): 改造个人中心页 — 横幅头像 + 卡片列表"
```

---

### Task 14: 优化搜索页 — ChoiceChip + 历史管理

**Files:**
- Modify: `news_check_app/lib/pages/search_page.dart`
- Modify: `news_check_app/lib/widgets/search_history_widget.dart`

- [ ] **Step 1: 重写 search_page.dart**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/search_history_controller.dart';
import 'package:news_check_app/widgets/search_history_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<String> _catalogs = ["新闻", "博客", "项目"];
  int _selectedCatalogIndex = 0;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showHistory = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("搜索")),
      body: GetBuilder(
        init: SearchHistoryController(),
        builder: (controller) {
          return Column(
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
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.addHistory(value);
                    }
                  },
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
                            setState(() {
                              _selectedCatalogIndex = i;
                            });
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              // 搜索历史
              if (_showHistory || controller.history.isNotEmpty)
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
              if (_showHistory)
                Expanded(
                  child: SearchHistoryWidget(
                    controller: controller,
                    onHistoryClick: (content) {
                      _textController.text = content;
                      debugPrint("点击搜索历史: $content");
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 2: 优化 search_history_widget.dart 中的 Chip**

修改 `SearchHistoryWidget`，为每个 Chip 添加 `onDeleted` 回调：

```dart
Widget _buildHistoryChildren() {
  List<Widget> result = [];
  for (final history in widget.controller.history) {
    result.add(
      Chip(
        label: Text(history),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: () {
          widget.controller.removeHistory(history);
        },
        onTap: () {
          widget.onHistoryClick(history);
        },
      ),
    );
  }
  return result;
}
```

- [ ] **Step 3: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 4: 提交**

```bash
git add news_check_app/lib/pages/search_page.dart
git add news_check_app/lib/widgets/search_history_widget.dart
git commit -m "feat(ui): 优化搜索页 — ChoiceChip + 历史管理"
```

---

### Task 15: 详情页骨架屏 + 错误状态

**Files:**
- Modify: `news_check_app/lib/pages/news_detail_page.dart`
- Modify: `news_check_app/lib/pages/blog_detail_page.dart`

- [ ] **Step 1: 修改 news_detail_page.dart — 替换 CircularProgressIndicator→ShimmerCard**

找到 `_buildBody` 方法中的 `CircularProgressIndicator`，替换为 `ShimmerCard`：

```dart
Widget _buildBody() {
  if (_loading) {
    return const ShimmerCard();
  } else if (_detail == null) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text("加载失败"),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _initData,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 40),
            ),
            child: const Text("重试"),
          ),
        ],
      ),
    );
  } else {
    return CommonDetailWebView(
      htmlContent: PassageUtils.htmlWrap(
        title: _detail!.title,
        author: _detail!.author,
        pubDate: _detail!.pubDate,
        body: _detail!.body,
      ),
      webViewKey: _webViewKey,
      onImageClick: (data) {
        handleImageClick(context, _webViewKey, data);
      },
    );
  }
}
```

同时添加 import: `import 'package:news_check_app/widgets/shimmer_loading.dart';`

- [ ] **Step 2: 同样修改 blog_detail_page.dart**

找到 `_buildBody` 方法中的 `CircularProgressIndicator`，替换为 `ShimmerCard`（同上模式）。
错误状态同样替换为带图标的重试按钮。

同时添加 import: `import 'package:news_check_app/widgets/shimmer_loading.dart';`

- [ ] **Step 3: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 4: 提交**

```bash
git add news_check_app/lib/pages/news_detail_page.dart
git add news_check_app/lib/pages/blog_detail_page.dart
git commit -m "feat(ui): 详情页骨架屏替换菊花，美化错误状态"
```

---

### Task 16: 优化底部导航栏 — 增加指示标签和图标尺寸

**Files:**
- Modify: `news_check_app/lib/widgets/bottom_navigation_bar.dart`

- [ ] **Step 1: 增加 MyNavigationBarItem 的 label 字段，更新 UI**

```dart
class MyNavigationBarItem {
  MyNavigationBarItem({
    required this.icon,
    required this.activeIcon,
    this.label,
  });

  final Widget icon;
  final Widget activeIcon;
  final String? label;
}
```

在 `_MyNavigationBarState._buildTabEntry()` 中，在图标下方显示 label：

```dart
Widget _buildTabEntry() {
  List<Widget> result = [];
  for (int i = 0; i < widget.tabs.length; i++) {
    result.add(
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.onPageChanged(_currentIndex, i);
            setState(() {
              _currentIndex = i;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _currentIndex == i
                  ? widget.tabs[i].activeIcon
                  : widget.tabs[i].icon,
              if (widget.tabs[i].label != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.tabs[i].label!,
                  style: TextStyle(
                    fontSize: 10,
                    color: _currentIndex == i
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    fontWeight: _currentIndex == i
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  return result;
}
```

同时将 Container 高度从 80 改为 64：

```dart
return Container(
  height: 64,
  width: double.infinity,
  ...
);
```

- [ ] **Step 2: 运行 flutter analyze 验证**

Run: `cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze`
Expected: 无 errors

- [ ] **Step 3: 提交**

```bash
git add news_check_app/lib/widgets/bottom_navigation_bar.dart
git commit -m "feat(ui): 优化底部导航栏 — 文字标签 + 高度调整"
```

---

## 最终验证

- [ ] **运行 flutter analyze 确认无错误**

```bash
cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter analyze
```

Expected: 0 errors, 0 warnings (可接受 pre-existing info)

- [ ] **运行 flutter test 确认不破坏功能**

```bash
cd /Users/graftcopolymer/project_course/mobile_development/final_homework/news_check_app && flutter test
```

Expected: 所有测试通过

---

## 自审检查

**1. Spec 覆盖:**
- ❓ 主题系统 → Task 2,3,4 ✅
- ❓ 首页布局 Header → Task 6,9 ✅
- ❓ TabBar 优化 → Task 9 ✅
- ❓ 瀑布流卡片 → Task 7,8,10,11 ✅
- ❓ 登录页改造 → Task 12 ✅
- ❓ 个人中心页 → Task 13 ✅
- ❓ 搜索页优化 → Task 14 ✅
- ❓ 详情页骨架屏 → Task 15 ✅
- ❓ Shimmer 组件 → Task 5 ✅
- ❓ 底部导航优化 → Task 16, Task 4 ✅
- ❓ 动效 → Task 12 登录动画, Task 9 TabBar ✅
- ❓ 依赖 → Task 1 ✅

**2. 占位符扫描:** 无 TBD/TODO/占位符 ✅
**3. 类型一致性:** 所有 import 路径和模型字段均对照实际文件 ✅
**4. 范围检查:** 所有改动在 Flutter 前端，不涉及后端 ✅