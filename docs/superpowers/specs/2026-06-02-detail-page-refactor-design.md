# 文章详情页重构 + 阅读个性化设计文档

> 重构新闻/博客详情页 UI，新增阅读个性化设置（字号/行距/背景色）、阅读进度条、底部操作栏、滚动感知收起/展开。

## 目标

- 统一的详情页 UI 布局（新闻和博客共用）
- 可持久化的阅读偏好设置（字号、行距、阅读模式）
- 实时 WebView 样式更新（JS 注入 CSS 变量，无闪烁）
- 底部操作栏随滚动滑入/滑出
- 预估阅读时间 + 文章元信息
- 阅读进度条指示器
- AppBar 阅读设置入口

## 页面布局

```
┌─ AppBar ────────────────────────────────────┐
│  ← 返回    文章标题               ⚙️ 设置    │
├──────────────────────────────────────────────┤
│  ██████████████████░░░░  (阅读进度条)        │
├──────────────────────────────────────────────┤
│                                              │
│  👤 作者名 · 🕐 发布时间                     │
│  📖 预估 X 分钟 · NNNN 字                   │
│                                              │
│  ┌─ WebView (文章正文) ──────────────────┐   │
│  │  (CSS 变量驱动：字号/行距/背景色)      │   │
│  │  实时更新无需重载页面                   │   │
│  └───────────────────────────────────────┘   │
│                                              │
├─ Bottom Bar ─────────────────────────────────┤
│  [Aa 字号]  [☰ 目录]  [⭐ 收藏]  [↗ 分享]  │
└──────────────────────────────────────────────┘
```

## 文件清单

### 新建 (4 个)

| 文件 | 说明 |
|------|------|
| `lib/controllers/reading_settings_controller.dart` | 阅读设置管理 + SharedPreferences 持久化 |
| `lib/widgets/detail_bottom_bar.dart` | 底部操作栏组件（滚动感知 + AnimatedSlide） |
| `lib/widgets/reading_settings_sheet.dart` | 阅读设置 BottomSheet（字号/行距/背景色） |
| `lib/widgets/detail_progress_bar.dart` | 顶部阅读进度条组件 |

### 修改 (4 个)

| 文件 | 说明 |
|------|------|
| `lib/pages/common_detail_webview.dart` | 接收阅读设置、JS CSS 变量注入、进度回传 |
| `lib/pages/news_detail_page.dart` | 整合新布局 |
| `lib/pages/blog_detail_page.dart` | 整合新布局 |
| `lib/utils/passage_utils.dart` | `htmlWrap` 增加 fontSize/lineSpacing/isDark 参数 |
| `lib/main.dart` | 注册 ReadingSettingsController |
| `DEV.md` | 更新功能状态 |

## ReadingSettingsController

```dart
enum ReadingBgMode { normal, sepia, dark }

class ReadingSettingsController extends GetxController {
  static const double defaultFontSize = 16;
  static const double defaultLineSpacing = 1.75;
  static const double minFontSize = 14;
  static const double maxFontSize = 24;
  static const double minLineSpacing = 1.2;
  static const double maxLineSpacing = 2.5;

  final fontSize = defaultFontSize.obs;
  final lineSpacing = defaultLineSpacing.obs;
  final readingBg = ReadingBgMode.normal.obs;

  // 计算属性
  Color get bgColor {
    switch (readingBg.value) {
      case ReadingBgMode.normal: return Colors.white;
      case ReadingBgMode.sepia:  return const Color(0xFFF5E6C8);
      case ReadingBgMode.dark:   return const Color(0xFF1E1E1E);
    }
  }

  Color get textColor {
    switch (readingBg.value) {
      case ReadingBgMode.normal: return const Color(0xFF1E293B);
      case ReadingBgMode.sepia:  return const Color(0xFF3E2E1A);
      case ReadingBgMode.dark:   return const Color(0xFFE0E0E0);
    }
  }

  Color get metaColor => textColor.withAlpha(150);

  Future<void> loadFromPrefs();
  Future<void> saveToPrefs();
  void resetToDefaults();

  /// 生成 JS 注入脚本来实时更新 WebView 样式
  String get injectCssVariablesJs => '''
    (function() {
      var root = document.documentElement;
      root.style.setProperty('--font-size', '${fontSize.value}px');
      root.style.setProperty('--line-height', '${lineSpacing.value}');
      root.style.setProperty('--bg-color', '${bgColor.toHex()}');
      root.style.setProperty('--text-color', '${textColor.toHex()}');
    })();
  ''';
}
```

## WebView CSS 变量架构

### 首次加载

`PassageUtils.htmlWrap()` 接收 `fontSize`、`lineSpacing`、`readingBg` 参数，生成带内联 CSS 变量的 HTML：

```dart
static String htmlWrap({
  String title = '',
  required String author,
  required String pubDate,
  required String body,
  bool isDark = false,
  double fontSize = 16,
  double lineSpacing = 1.75,
}) {
  // isDark 决定文字/背景基础色调
  // fontSize/lineSpacing 作为 CSS 变量初始值
  // ...
  return '''
    <html>
    <head>
      <style>
        :root {
          --font-size: ${fontSize}px;
          --line-height: ${lineSpacing};
          ...
        }
        body {
          font-size: var(--font-size);
          line-height: var(--line-height);
          ...
        }
      </style>
    </head>
    <body>
      $body
    </body>
    </html>
  ''';
}
```

### 实时更新

用户调整滑杆时，`ReadingSettingsController` 的值变化触发 `CommonDetailWebView` 调用：

```dart
_controller.runJavaScript(readingSettingsController.injectCssVariablesJs);
```

WebView 无闪烁更新样式。

## 阅读进度条

### WebView JS（扩展 imageClickJs 同级别）

```js
window.onscroll = function() {
  var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
  var scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  if (scrollHeight <= 0) return;
  var progress = Math.round(scrollTop / scrollHeight * 100);
  ReadingProgress.postMessage(JSON.stringify({progress: progress, scrollTop: scrollTop}));
};
```

### App 端

新增 JavaScriptChannel `ReadingProgress`，接收进度百分比后更新 `DetailProgressBar` 的状态。

同时利用 `scrollTop` 判断滚动方向，控制底部栏的显示/隐藏（阈值 10px 防抖）。

## 文章目录 TOC

### 实现方式

在 `PassageUtils` 中新增 `enhanceHtmlWithToc()` 方法：

1. 解析 body HTML 中所有的 `<h1>`、`<h2>`、`<h3>` 标签
2. 为每个标题添加 `id` 属性：`<h2 id="toc-0">原文标题</h2>`
3. 返回增强后的 HTML + 标题列表（用于 BottomSheet 展示）

```dart
class TocEntry {
  final String id;      // "toc-0", "toc-1"
  final String text;    // 标题文本
  final int level;      // 1, 2, 3
}

static (String html, List<TocEntry> toc) enhanceHtmlWithToc(String body) {
  final entries = <TocEntry>[];
  int index = 0;
  final result = body.replaceAllMapped(
    RegExp(r'<h([1-3])([^>]*)>(.*?)</h\1>', caseSensitive: false, dotAll: true),
    (match) {
      final level = int.parse(match.group(1)!);
      final attrs = match.group(2)!;
      final text = match.group(3)!;
      // 去掉已有 id 避免冲突
      final cleanAttrs = attrs.replaceAll(RegExp(r'\bid\s*=\s*"[^"]*"', caseSensitive: false), '');
      final id = 'toc-$index';
      entries.add(TocEntry(id: id, text: _stripHtml(text), level: level));
      index++;
      return '<h$level$cleanAttrs id="$id">$text</h$level>';
    },
  );
  return (result, entries);
}
```

### 点击目录项

注入 JS 平滑滚动到对应锚点：

```js
document.getElementById('toc-3').scrollIntoView({behavior: 'smooth', block: 'start'});
```

### 无标题文章

若解析后 `entries` 为空，BottomSheet 显示"本文无目录"。

## 底部操作栏 `DetailBottomBar`

```dart
class DetailBottomBar extends StatelessWidget {
  final bool isVisible;                // 由外部控制（滚动状态）
  final VoidCallback onFontSettings;    // Aa 字号
  final VoidCallback onToc;             // ☰ 目录
  final VoidCallback onBookmark;        // ⭐ 收藏
  // ↗ 分享在本次实现中 disable
}
```

包裹在 `AnimatedSlide` 中：

```dart
AnimatedSlide(
  offset: isVisible ? Offset.zero : Offset(0, 1),  // 下滑隐藏
  duration: Duration(milliseconds: 200),
  child: DetailBottomBar(...),
)
```

## 阅读设置面板 `ReadingSettingsSheet`

展示为 BottomSheet，包含：
1. 字号滑杆（14-24，步长 1）
2. 行距滑杆（1.2-2.5，步长 0.05）
3. 阅读模式选择器（白色 / 护眼 / 深色，三个 Chips）
4. 底部"恢复默认"按钮

每个调整触发 `ReadingSettingsController` 更新 → `CommonDetailWebView` 注入 JS → 实时生效。

## 滚动感知逻辑

在 `common_detail_webview.dart` 中：
- 从 JS 接收 `scrollTop`
- 缓存上一次 `scrollTop`，计算差值
- 差值 > 10px 向下 → 隐藏底部栏
- 差值 < -10px 向上 → 显示底部栏
- 进度条百分比直接更新

## DEV.md 更新

需要勾选：
- 离线阅读缓存 ✅
- 阅读统计 ✅
- 下拉刷新定制 ✅
- 阅读偏好设置（字号/行距/护眼模式）→ 标记 ✅

## 依赖

无需新增外部依赖。所有功能基于现有：
- `flutter_webview`（JS 注入 + JavaScriptChannel）
- `get`（GetX 状态管理）
- `shared_preferences`（持久化阅读设置）