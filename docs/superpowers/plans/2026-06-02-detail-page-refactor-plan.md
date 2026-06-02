# 文章详情页重构 + 阅读个性化 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 重构新闻/博客详情页 UI，新增阅读个性化设置（字号/行距/背景色）、阅读进度条、文章目录、滚动感知底部操作栏

**Architecture:** ReadingSettingsController (GetX + SharedPreferences) → CSS 变量注入 WebView → 底部栏 AnimatedSlide 随滚动滑入/滑出 → TOC 从 HTML 解析标题锚点

**Tech Stack:** WebView JavaScriptChannel, GetX, SharedPreferences, AnimatedSlide

---

## 文件清单

### 新建 (4 个)

| 文件 | 说明 |
|------|------|
| `lib/controllers/reading_settings_controller.dart` | 阅读设置管理 + 持久化 |
| `lib/widgets/detail_bottom_bar.dart` | 底部操作栏组件 |
| `lib/widgets/reading_settings_sheet.dart` | 阅读设置 BottomSheet |
| `lib/widgets/detail_progress_bar.dart` | 阅读进度条组件 |

### 修改 (4 个)

| 文件 | 说明 |
|------|------|
| `lib/pages/common_detail_webview.dart` | 接收设置、JS 注入、进度/滚动回传 |
| `lib/pages/news_detail_page.dart` | 新 UI 布局 |
| `lib/pages/blog_detail_page.dart` | 新 UI 布局 |
| `lib/utils/passage_utils.dart` | `htmlWrap` 增加 CSS 变量 + `enhanceHtmlWithToc` |
| `lib/main.dart` | 注册 ReadingSettingsController |
| `DEV.md` | 更新状态 |

---

### Task 1: 创建 ReadingSettingsController

**Files:**
- Create: `news_check_app/lib/controllers/reading_settings_controller.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/utils/store_keys.dart';
import 'package:news_check_app/utils/store_utils.dart';

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

  String hexColor(Color c) {
    return '#${c.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  String get injectCssVariablesJs => '''
    (function() {
      var root = document.documentElement;
      root.style.setProperty('--font-size', '${fontSize.value}px');
      root.style.setProperty('--line-height', '${lineSpacing.value}');
      root.style.setProperty('--bg-color', '${hexColor(bgColor)}');
      root.style.setProperty('--text-color', '${hexColor(textColor)}');
      root.style.setProperty('--meta-color', '${hexColor(metaColor)}');
    })();
  ''';

  @override
  void onInit() {
    super.onInit();
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = StoreUtils.pref;
    fontSize.value = prefs.getDouble('reading_font_size') ?? defaultFontSize;
    lineSpacing.value = prefs.getDouble('reading_line_spacing') ?? defaultLineSpacing;
    final bgIdx = prefs.getInt('reading_bg_mode') ?? 0;
    readingBg.value = ReadingBgMode.values[bgIdx.clamp(0, ReadingBgMode.values.length - 1)];
  }

  Future<void> saveToPrefs() async {
    final prefs = StoreUtils.pref;
    await prefs.setDouble('reading_font_size', fontSize.value);
    await prefs.setDouble('reading_line_spacing', lineSpacing.value);
    await prefs.setInt('reading_bg_mode', readingBg.index);
  }

  void resetToDefaults() {
    fontSize.value = defaultFontSize;
    lineSpacing.value = defaultLineSpacing;
    readingBg.value = ReadingBgMode.normal;
    saveToPrefs();
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/controllers/reading_settings_controller.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "feat: add ReadingSettingsController"
```

---

### Task 2: 更新 PassageUtils — CSS 变量 htmlWrap + TOC 解析

**Files:**
- Modify: `news_check_app/lib/utils/passage_utils.dart`

- [ ] **Step 1: 添加 TOC 增强方法 + 更新 htmlWrap 签名**

在 `class PassageUtils` 中添加：

```dart
/// 目录条目
class TocEntry {
  final String id;
  final String text;
  final int level;
  TocEntry({required this.id, required this.text, required this.level});
}

// 在 PassageUtils 类中新增方法：

/// 为 HTML 中的 h1/h2/h3 添加锚点 id，同时返回标题列表
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
      final cleanAttrs = attrs.replaceAll(
        RegExp(r'\bid\s*=\s*"[^"]*"', caseSensitive: false), '');
      final id = 'toc-$index';
      entries.add(TocEntry(id: id, text: text.replaceAll(RegExp(r'<[^>]*>'), ''), level: level));
      index++;
      return '<h$level$cleanAttrs id="$id">$text</h$level>';
    },
  );
  return (result, entries);
}
```

修改 `htmlWrap` 方法签名，增加 `fontSize` 和 `lineSpacing` 参数，CSS 改用 `var()` 变量：

```dart
static String htmlWrap({
  String title = '',
  required String author,
  required String pubDate,
  required String body,
  bool isDark = false,
  double fontSize = 16,
  double lineSpacing = 1.75,
  bool isSepia = false,
}) {
  // isDark 和 isSepia 任一个为 true 时使用对应背景色
  final bgColor = isSepia ? '#F5E6C8' : (isDark ? '#121212' : '#ffffff');
  final textColor = isSepia ? '#3E2E1A' : (isDark ? '#e0e0e0' : '#1e293b');
  final metaColor = isSepia ? '#6B5D4D' : (isDark ? '#94a3b8' : '#64748b');

  return """
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0">
      <style>
        :root {
          --font-size: ${fontSize}px;
          --line-height: ${lineSpacing};
          --bg-color: $bgColor;
          --text-color: $textColor;
          --meta-color: $metaColor;
          --hr-color: ${isDark ? '#334155' : '#e2e8f0'};
          --code-bg: ${isDark ? '#1e293b' : '#f1f5f9'};
          --code-border: ${isDark ? '#475569' : '#cbd5e1'};
          --link-color: ${isDark ? '#67e8f9' : '#0d9488'};
          --blockquote-border: ${isDark ? '#14b8a6' : '#0d9488'};
          --blockquote-bg: ${isDark ? '#1e293b' : '#f0fdfa'};
        }
        * { box-sizing: border-box; }
        body {
          font-family: -apple-system, 'PingFang SC', 'Noto Sans CJK SC', sans-serif;
          font-size: var(--font-size);
          line-height: var(--line-height);
          word-wrap: break-word;
          padding: 16px;
          margin: 0;
          background-color: var(--bg-color);
          color: var(--text-color);
          transition: background-color 0.15s, color 0.15s;
        }
        // ... 其余 CSS 使用 var() 引用变量
        h1 { font-size: calc(var(--font-size) * 1.375); margin: 16px 0 8px; font-weight: 700; }
        h2 { font-size: calc(var(--font-size) * 1.1875); margin: 20px 0 8px; font-weight: 600; }
        h3 { font-size: calc(var(--font-size) * 1.0625); margin: 16px 0 6px; font-weight: 600; }
        p { margin: 10px 0; }
        a { color: var(--link-color); text-decoration: none; }
        img { max-width: 100%; height: auto; display: block; margin: 12px auto; border-radius: 8px; cursor: pointer; }
        hr { border: none; height: 1px; background-color: var(--hr-color); margin: 20px 0; }
        pre { background-color: var(--code-bg); border: 1px solid var(--code-border); border-radius: 8px; padding: 14px; overflow-x: auto; font-size: calc(var(--font-size) * 0.875); }
        code { font-family: 'SF Mono', 'Fira Code', monospace; font-size: calc(var(--font-size) * 0.875); background-color: var(--code-bg); padding: 2px 6px; border-radius: 4px; }
        pre code { background: none; padding: 0; }
        blockquote { margin: 12px 0; padding: 10px 16px; border-left: 4px solid var(--blockquote-border); background-color: var(--blockquote-bg); border-radius: 0 6px 6px 0; }
        table { border-collapse: collapse; width: 100%; margin: 12px 0; }
        th, td { border: 1px solid var(--hr-color); padding: 8px 12px; text-align: left; }
        th { background-color: var(--code-bg); font-weight: 600; }
        ul, ol { padding-left: 24px; margin: 8px 0; }
        li { margin: 4px 0; }
        .meta { color: var(--meta-color); display: flex; justify-content: space-between; font-size: calc(var(--font-size) * 0.875); margin-bottom: 4px; }
      </style>
    </head>
    <body>${title.isEmpty ? '' : '<h1>$title</h1>'}
      <div class="meta">
        <span>作者: $author</span>
        <span>$pubDate</span>
      </div>
      <hr/>$body</body></html>
  """;
}
```

更新 `wrapBodyForWebView` 以调用新的 `enhanceHtmlWithToc`：

```dart
static (String html, List<TocEntry> toc) wrapBodyForWebView({
  required String title,
  required String author,
  required String pubDate,
  required String body,
  required bool isDark,
  double fontSize = 16,
  double lineSpacing = 1.75,
}) {
  // Markdown → HTML 转换
  final htmlBody = detectType(body) == ContentType.markdown
      ? md.markdownToHtml(body)
      : body;
  // TOC 增强
  final (enhancedBody, toc) = enhanceHtmlWithToc(htmlBody);
  final wrapped = htmlWrap(
    title: title, author: author, pubDate: pubDate,
    body: enhancedBody, isDark: isDark,
    fontSize: fontSize, lineSpacing: lineSpacing,
  );
  return (wrapped, toc);
}
```

注意：需要将返回类型改为 `(String, List<TocEntry>)`。现有的调用方（news_detail_page/blog_detail_page）需要适配。

同时保留旧版 `htmlWrap`（加默认参数）向后兼容。

- [ ] **Step 2: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "^\s*(error)" | head -5
```
Expected: 0 errors

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/utils/passage_utils.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "feat: update PassageUtils with TOC parsing and CSS variable htmlWrap"
```

---

### Task 3: 创建 DetailProgressBar 组件

**Files:**
- Create: `news_check_app/lib/widgets/detail_progress_bar.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';

class DetailProgressBar extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0

  const DetailProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: 2.5,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/widgets/detail_progress_bar.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "feat: add DetailProgressBar widget"
```

---

### Task 4: 创建 DetailBottomBar 组件

**Files:**
- Create: `news_check_app/lib/widgets/detail_bottom_bar.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';

class DetailBottomBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onFontSettings;
  final VoidCallback onToc;
  final VoidCallback onBookmark;

  const DetailBottomBar({
    super.key,
    required this.isVisible,
    required this.onFontSettings,
    required this.onToc,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BarButton(
                    icon: Icons.text_fields,
                    label: '字号',
                    onTap: onFontSettings,
                  ),
                  _BarButton(
                    icon: Icons.list_alt,
                    label: '目录',
                    onTap: onToc,
                  ),
                  _BarButton(
                    icon: Icons.bookmark_border,
                    label: '收藏',
                    onTap: onBookmark,
                  ),
                  _BarButton(
                    icon: Icons.share_outlined,
                    label: '分享',
                    onTap: null, // disabled
                    disabled: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool disabled;

  const _BarButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = disabled
        ? colorScheme.onSurface.withAlpha(80)
        : colorScheme.onSurface;
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: foreground),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: foreground)),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/widgets/detail_bottom_bar.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "feat: add DetailBottomBar with AnimatedSlide show/hide"
```

---

### Task 5: 创建 ReadingSettingsSheet

**Files:**
- Create: `news_check_app/lib/widgets/reading_settings_sheet.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/reading_settings_controller.dart';

class ReadingSettingsSheet extends StatefulWidget {
  const ReadingSettingsSheet({super.key});

  @override
  State<ReadingSettingsSheet> createState() => _ReadingSettingsSheetState();
}

class _ReadingSettingsSheetState extends State<ReadingSettingsSheet> {
  late final ReadingSettingsController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ReadingSettingsController>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Center(
            child: Container(
              width: 32, height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('阅读设置', style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),

          // 字号滑杆
          _buildSliderLabel('字号', '${_ctrl.fontSize.value.round()}'),
          _buildSlider(
            value: _ctrl.fontSize.value,
            min: ReadingSettingsController.minFontSize,
            max: ReadingSettingsController.maxFontSize,
            divisions: 10,
            onChanged: (v) {
              _ctrl.fontSize.value = v;
              _ctrl.saveToPrefs();
            },
          ),
          const SizedBox(height: 16),

          // 行距滑杆
          _buildSliderLabel('行距', _ctrl.lineSpacing.value.toStringAsFixed(2)),
          _buildSlider(
            value: _ctrl.lineSpacing.value,
            min: ReadingSettingsController.minLineSpacing,
            max: ReadingSettingsController.maxLineSpacing,
            divisions: 26,
            onChanged: (v) {
              _ctrl.lineSpacing.value = v;
              _ctrl.saveToPrefs();
            },
          ),
          const SizedBox(height: 16),

          // 阅读模式
          _buildSliderLabel('阅读模式', ''),
          const SizedBox(height: 8),
          Row(
            children: [
              _modeChip('白色', ReadingBgMode.normal),
              const SizedBox(width: 8),
              _modeChip('护眼', ReadingBgMode.sepia),
              const SizedBox(width: 8),
              _modeChip('深色', ReadingBgMode.dark),
            ],
          ),
          const SizedBox(height: 20),

          // 恢复默认
          Center(
            child: TextButton(
              onPressed: () {
                _ctrl.resetToDefaults();
                // 强制触发 inject
                _ctrl.fontSize.refresh();
              },
              child: const Text('恢复默认设置'),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildSliderLabel(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
    );
  }

  Widget _modeChip(String label, ReadingBgMode mode) {
    final selected = _ctrl.readingBg.value == mode;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        _ctrl.readingBg.value = mode;
        _ctrl.saveToPrefs();
      },
    );
  }
}

/// Show reading settings as a modal bottom sheet
Future<void> showReadingSettingsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ReadingSettingsSheet(),
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/widgets/reading_settings_sheet.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "feat: add ReadingSettingsSheet bottom sheet"
```

---

### Task 6: 重构 CommonDetailWebView

**Files:**
- Modify: `news_check_app/lib/pages/common_detail_webview.dart`

- [ ] **Step 1: 重写 CommonDetailWebView**

```dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_check_app/controllers/reading_settings_controller.dart';
import 'package:news_check_app/utils/passage_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonDetailWebView extends StatefulWidget {
  const CommonDetailWebView({
    super.key,
    required this.htmlContent,
    required this.webViewKey,
    this.onImageClick,
    this.onProgressChanged,     // 阅读进度回调 0-100
    this.onScrollChanged,       // 滚动位置回调
    required this.tocEntries,   // 目录条目
  });

  final String htmlContent;
  final GlobalKey webViewKey;
  final Function(Map<String, dynamic> data)? onImageClick;
  final Function(int progress)? onProgressChanged;
  final Function(int scrollTop)? onScrollChanged;
  final List<TocEntry> tocEntries;
  final ValueNotifier<String?>? scrollToTocNotifier;

  @override
  State<CommonDetailWebView> createState() => _CommonDetailWebViewState();
}

class _CommonDetailWebViewState extends State<CommonDetailWebView> {
  final _settingsCtrl = Get.find<ReadingSettingsController>();

  /// 注入 CSS 变量更新
  void injectSettings() {
    _controller.runJavaScript(_settingsCtrl.injectCssVariablesJs);
  }

  /// 注入滚动监听 + 图片点击 + 初始 CSS 变量
  String get _injectAllJs => '''
    (function() {
      // CSS 变量初始化
      ${_settingsCtrl.injectCssVariablesJs.replaceAll('(function() {', '').replaceAll('})();', '')}

      // 图片点击
      var imgs = document.getElementsByTagName('img');
      var ratio = window.devicePixelRatio || 1;
      for (var i = 0; i < imgs.length; i++) {
        imgs[i].onclick = function() {
          var rect = this.getBoundingClientRect();
          ImageHeroApp.postMessage(JSON.stringify({
            src: this.src,
            x: rect.left * ratio, y: rect.top * ratio,
            width: rect.width * ratio, height: rect.height * ratio
          }));
        };
      }

      // 滚动监听（阅读进度 + 滚动方向）
      var ticking = false;
      window.onscroll = function() {
        if (!ticking) {
          window.requestAnimationFrame(function() {
            var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
            var scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            if (scrollHeight > 0) {
              var progress = Math.round(scrollTop / scrollHeight * 100);
              ReadingProgress.postMessage(JSON.stringify({
                progress: progress,
                scrollTop: scrollTop
              }));
            }
            ticking = false;
          });
          ticking = true;
        }
      };
    })();
  ''';

  @override
  void initState() {
    super.initState();
    // 监听目录跳转指令
    widget.scrollToTocNotifier?.addListener(_onScrollToTocCommand);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final uri = Uri.parse(request.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              await Fluttertoast.showToast(msg: "未检测到手机浏览器");
            }
            return NavigationDecision.prevent;
          },
          onPageFinished: (_) {
            _controller.runJavaScript(_injectAllJs);
          },
        ),
      )
      ..addJavaScriptChannel(
        "ImageHeroApp",
        onMessageReceived: (msg) {
          final data = jsonDecode(msg.message);
          widget.onImageClick?.call(data);
        },
      )
      ..addJavaScriptChannel(
        "ReadingProgress",
        onMessageReceived: (msg) {
          final data = jsonDecode(msg.message) as Map<String, dynamic>;
          final progress = data['progress'] as int;
          final scrollTop = data['scrollTop'] as int;
          widget.onProgressChanged?.call(progress);
          widget.onScrollChanged?.call(scrollTop);
        },
      )
      ..loadHtmlString(widget.htmlContent);
  }

  void _onScrollToTocCommand() {
    final tocId = widget.scrollToTocNotifier?.value;
    if (tocId != null) {
      _controller.runJavaScript('''
        document.getElementById('$tocId').scrollIntoView({behavior: 'smooth', block: 'start'});
      ''');
    }
  }

  @override
  void dispose() {
    widget.scrollToTocNotifier?.removeListener(_onScrollToTocCommand);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(key: widget.webViewKey, controller: _controller);
}
```

- [ ] **Step 2: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "^\s*(error)" | head -5
```
Expected: 0 errors

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/pages/common_detail_webview.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "refactor: CommonDetailWebView with settings injection, progress channel, TOC scroll"
```

---

### Task 7: 重构 NewsDetailPage — 新 UI 布局

**Files:**
- Modify: `news_check_app/lib/pages/news_detail_page.dart`

- [ ] **Step 1: 重写文件**

完整重写 `news_detail_page.dart`，整合：
- 顶部阅读进度条 `DetailProgressBar`
- 文章元信息（作者、时间、预估阅读时间）
- `CommonDetailWebView`（传递 TOC 条目 + 设置注入）
- 底部操作栏 `DetailBottomBar`（滚动感知）
- AppBar 右侧 ⚙️ 阅读设置入口
- 阅读设置 BottomSheet

核心 UI 结构：

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("详情"),
      actions: [
        IconButton(
          icon: const Icon(Icons.text_fields),
          tooltip: '阅读设置',
          onPressed: () => showReadingSettingsSheet(context),
        ),
      ],
    ),
    body: Stack(
      children: [
        Column(
          children: [
            // 阅读进度条
            DetailProgressBar(progress: _readProgress / 100.0),
            // 元信息
            if (_detail != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Text(_detail!.author[0], style: const TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_detail!.author, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          Text('${_detail!.pubDate} · 约 ${_estimatedMinutes} 分钟 · ${_wordCount} 字',
                            style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // WebView
            Expanded(child: _buildWebView()),
          ],
        ),
        // 底部操作栏
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: DetailBottomBar(
            isVisible: _showBottomBar,
            onFontSettings: () => showReadingSettingsSheet(context),
            onToc: _showToc,
            onBookmark: () => Fluttertoast.showToast(msg: "收藏功能开发中"),
          ),
        ),
      ],
    ),
  );
}
```

添加状态变量和方法：
- `_readProgress` (int) — 阅读进度
- `_showBottomBar` (bool) — 底部栏可见性
- `_lastScrollTop` (int) — 上次滚动位置
- `_tocEntries` (List<TocEntry>) — 目录条目
- `_scrollToTocNotifier` (ValueNotifier<String?>) — 目录跳转指令通道
- `_wordCount` (int) — 文章字数
- `_estimatedMinutes` (int) — 预估阅读时间

处理 `_initData` 中使用新的 `wrapBodyForWebView` 返回值：

```dart
final (htmlContent, toc) = PassageUtils.wrapBodyForWebView(
  title: _detail!.title,
  author: _detail!.author,
  pubDate: _detail!.pubDate,
  body: _detail!.body,
  isDark: Get.isDarkMode,
  fontSize: _settingsCtrl.fontSize.value,
  lineSpacing: _settingsCtrl.lineSpacing.value,
);
_tocEntries = toc;
_wordCount = PassageUtils.countReadableChars(_detail!.body);
_estimatedMinutes = (_wordCount / 300).ceil().clamp(1, 999);
```

滚动逻辑：
```dart
void _onScrollChanged(int scrollTop) {
  final delta = scrollTop - _lastScrollTop;
  if (delta.abs() > 10) {
    if (delta > 0 && _showBottomBar) {
      setState(() => _showBottomBar = false);
    } else if (delta < 0 && !_showBottomBar) {
      setState(() => _showBottomBar = true);
    }
  }
  _lastScrollTop = scrollTop;
}
```

目录弹窗：
```dart
void _showToc() {
  if (_tocEntries.isEmpty) {
    Fluttertoast.showToast(msg: "本文无目录");
    return;
  }
  showModalBottomSheet(
    context: context,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('文章目录', style: Theme.of(context).textTheme.titleMedium),
        ),
        ..._tocEntries.map((e) => ListTile(
          leading: Text('H${e.level}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
          title: Text(e.text, maxLines: 2, overflow: TextOverflow.ellipsis),
          dense: true,
          onTap: () {
            Get.back();
            _scrollToTocNotifier.value = e.id;
          },
        )),
      ],
    ),
  );
}
```

使用 `ValueNotifier<String?>` 作为指令通道，避免暴露子组件状态类型。`CommonDetailWebView` 内部监听此 notifier，收到非 null 值即执行 JS scrollIntoView。

- [ ] **Step 2: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "^\s*(error)" | head -5
```
Expected: 0 errors

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/pages/news_detail_page.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "refactor: NewsDetailPage with progress bar, bottom bar, TOC, reading settings"
```

---

### Task 8: 同步重构 BlogDetailPage

**Files:**
- Modify: `news_check_app/lib/pages/blog_detail_page.dart`

- [ ] **Step 1: 应用与 Task 7 完全相同的 UI 重构到 blog_detail_page.dart**

与 news_detail_page 结构一致，区别仅为：
- `type: 'blog'`（用于缓存 key）
- 调用 `api.blogDetailIdGet`
- 调用 `BlogDetail.fromJson`
- 元信息 `type: 'blog'`

其余 UI 布局、进度条、底部栏、目录、阅读设置完全共享。

- [ ] **Step 2: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "^\s*(error)" | head -5
```
Expected: 0 errors

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/pages/blog_detail_page.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "refactor: BlogDetailPage with same new layout as NewsDetailPage"
```

---

### Task 9: 注册 ReadingSettingsController 在 main.dart 中

**Files:**
- Modify: `news_check_app/lib/main.dart`

- [ ] **Step 1: 添加注册**

```dart
import 'package:news_check_app/controllers/reading_settings_controller.dart';
// 在 Get.put(ReadingStatsController()); 后面添加：
Get.put(ReadingSettingsController());
```

- [ ] **Step 2: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "^\s*(error)" | head -5
```
Expected: 0 errors

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/main.dart
git -C "$(git rev-parse --show-toplevel)" commit -m "feat: register ReadingSettingsController in main.dart"
```

---

### Task 10: 更新 DEV.md — 标记新增功能

**Files:**
- Modify: `DEV.md`

- [ ] **Step 1: 在 DEV.md 的已实现功能表中新增条目**

在 "下拉刷新定制" 行下方添加：

```
| 阅读个性化设置 | ✅ 完成 | N/A | 字号/行距/护眼模式，实时 CSS 注入 |
| 阅读进度条 | ✅ 完成 | N/A | WebView 滚动顶部进度指示器 |
| 文章目录 TOC | ✅ 完成 | N/A | 从 h1/h2/h3 自动生成，点击跳转 |
| 底部操作栏 | ✅ 完成 | N/A | 滚动感知滑入/滑出，阅读设置/目录/收藏 |
```

同时更新 "推荐开发顺序" 中的 P2 功能 10（阅读偏好设置）标记为 ✅。

- [ ] **Step 2: Commit**

```bash
git add DEV.md
git -C "$(git rev-parse --show-toplevel)" commit -m "docs: update DEV.md with new detail page features"
```