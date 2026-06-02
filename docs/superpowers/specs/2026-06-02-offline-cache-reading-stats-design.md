# 离线缓存 + 阅读统计设计文档

> **S 级 — 面试亮点**

## 目标

- 新闻/博客详情页加载成功后自动缓存到本地，支持离线阅读
- APP 级图片下载队列，预下载文章图片到本地
- 记录阅读历史，统计阅读篇数、字数、趋势
- 设置页管理缓存，统计页展示数据

## 架构概览

```
┌─────────────────────────────────────────────────┐
│                   Flutter APP                    │
│                                                  │
│  ┌─────────────────────────────────────────────┐ │
│  │              Controllers                     │ │
│  │  ┌─────────────────┐ ┌───────────────────┐  │ │
│  │  │OfflineCacheCtrl │ │ReadingStatsCtrl    │  │ │
│  │  └────────┬────────┘ └────────┬──────────┘  │ │
│  │           │                   │              │ │
│  ├───────────┴───────────────────┴──────────────┤ │
│  │              Data Layer                      │ │
│  │  ┌──────────────┐ ┌──────────────────────┐  │ │
│  │  │ CacheDao     │ │ ReadHistoryDao       │  │ │
│  │  └──────┬───────┘ └─────────┬────────────┘  │ │
│  │         │                   │                │ │
│  │  ┌──────┴───────────────────┴────┐           │ │
│  │  │   DatabaseHelper (sqflite)    │           │ │
│  │  └───────────────────────────────┘           │ │
│  │                                              │ │
│  │  ┌─────────────────────────────────────┐     │ │
│  │  │ ImageDownloadService (APP 级任务队列)│     │ │
│  │  └─────────────────────────────────────┘     │ │
│  └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

## 文件清单

### 新建文件

| 文件 | 职责 |
|------|------|
| `lib/database/database_helper.dart` | sqflite 单例：初始化、建表、迁移 |
| `lib/database/cache_dao.dart` | 缓存 CRUD + image_cache 联合操作 |
| `lib/database/read_history_dao.dart` | 阅读记录 CRUD + 统计聚合查询 |
| `lib/utils/image_download_service.dart` | APP 级任务队列：图片下载、本地存储、状态管理 |
| `lib/controllers/offline_cache_controller.dart` | GetX 控制器，管理缓存状态和响应式更新 |
| `lib/controllers/reading_stats_controller.dart` | GetX 控制器，管理阅读统计和响应式更新 |
| `lib/pages/stats_page.dart` | 阅读统计页面（折线图 + 饼图） |

### 修改文件

| 文件 | 改动 |
|------|------|
| `pubspec.yaml` | 新增 `sqflite`, `path_provider`, `fl_chart`, `crypto` |
| `lib/main.dart` | 初始化 DatabaseHelper + ImageDownloadService |
| `lib/pages/news_detail_page.dart` | 成功后调用 CacheDao.insert() + ReadHistoryDao.recordRead() |
| `lib/pages/blog_detail_page.dart` | 同上 |
| `lib/pages/news_tab.dart` | 返回列表时刷新缓存状态 |
| `lib/pages/blog_tab.dart` | 同上 |
| `lib/pages/settings_page.dart` | 新增"缓存管理"分组 |
| `lib/widgets/staggered_news_card.dart` | 右上角"已缓存"标记 |
| `lib/widgets/staggered_blog_card.dart` | 右上角"已缓存"标记 |
| `lib/pages/account_page.dart` | 新增"阅读统计"入口 |

## 数据库设计

### 表 1: `cache_items`

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `item_type` | TEXT | NOT NULL | `"news"` 或 `"blog"` |
| `item_id` | INTEGER | NOT NULL | OSCHINA 文章 ID |
| `title` | TEXT | NOT NULL | 标题 |
| `author` | TEXT | NOT NULL | 作者 |
| `pub_date` | TEXT | NOT NULL | 发布日期 |
| `body` | TEXT | NOT NULL | 原始 HTML（含外部图片 URL） |
| `local_body` | TEXT | 可为 NULL | 图片路径替换为本地后的 HTML |
| `cached_at` | INTEGER | NOT NULL | 缓存时间戳 |

> 主键: `(item_type, item_id)` 联合主键。`local_body` 初始为 NULL，由 ImageDownloadService 逐步填充。

### 表 2: `image_cache`

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | 自增主键 |
| `cache_key` | TEXT | NOT NULL | `"news_123"` 关联 cache_items |
| `original_url` | TEXT | NOT NULL | 原始图片 URL |
| `local_path` | TEXT | 可为 NULL | 下载完成后的本地路径 |
| `status` | TEXT | NOT NULL DEFAULT `'pending'` | `pending` / `downloading` / `completed` / `failed` |

> 唯一约束: `(cache_key, original_url)`。同一 URL 在同一篇文章中只存一条。

### 表 3: `read_history`

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | 自增主键 |
| `item_type` | TEXT | NOT NULL | `"news"` 或 `"blog"` |
| `item_id` | INTEGER | NOT NULL | 文章 ID |
| `title` | TEXT | NOT NULL | 标题（冗余，方便统计页直接展示） |
| `word_count` | INTEGER | NOT NULL | 阅读字数（去 HTML 标签后的有效字符数） |
| `read_at` | INTEGER | NOT NULL | 阅读时间戳 |

> 索引: `CREATE INDEX idx_read_history_read_at ON read_history(read_at)`

## 数据层接口

### CacheDao

```dart
class CacheDao {
  /// 缓存或更新文章（UPSERT 语义）
  static Future<void> insert({
    required String type,
    required int id,
    required String title,
    required String author,
    required String pubDate,
    required String body,
  });

  /// 查询是否已缓存
  static Future<bool> exists(String type, int id);

  /// 获取缓存文章详情（含 body/local_body）
  static Future<CachedItem?> get(String type, int id);

  /// 获取所有缓存的 "type_id" 集合
  static Future<Set<String>> getAllKeys();

  /// 删除单条缓存（含关联 image_cache）
  static Future<void> delete(String type, int id);

  /// 清空所有缓存（含 image_cache 和本地图片文件）
  static Future<void> clearAll();

  /// 统计缓存数据总字节数（含图片文件大小）
  static Future<int> getTotalSize();
}
```

### ImageDownloadService

```dart
class ImageDownloadService {
  static final ImageDownloadService instance = ImageDownloadService._();

  /// 初始化：检查未完成的下载任务，重新入队
  Future<void> init();

  /// 为文章添加图片下载任务
  /// [cacheKey] = "news_123"
  /// [imageUrls] = ["https://...", ...]
  void enqueueImageDownloads(String cacheKey, List<String> imageUrls);

  /// 暂停队列
  void pause();

  /// 恢复队列
  void resume();

  /// 停止队列（APP 销毁时）
  void dispose();

  // 并发数: 3
  // 队列处理逻辑:
  //   1. 从队列取出一个任务
  //   2. 用 Dio 下载图片
  //   3. 写入 {appDocDir}/.cache_images/{md5(url)}.{ext}
  //   4. 更新 image_cache 表 status='completed', local_path
  //   5. 更新 cache_items 表 local_body（逐步替换已完成的图片 URL）
  //   6. 下载失败则 status='failed'
  //   7. 取下一个任务
  // 重试: failed 的任务在下次 init() 时重新入队（最多重试 2 次）
}
```

### ReadHistoryDao

```dart
class ReadHistoryDao {
  /// 记录一次阅读
  static Future<void> recordRead({
    required String type,
    required int id,
    required String title,
    required int wordCount,
  });

  /// 今日阅读篇数
  static Future<int> getTodayCount();

  /// 累计阅读篇数
  static Future<int> getTotalCount();

  /// 今日阅读字数
  static Future<int> getTodayWordCount();

  /// 累计阅读字数
  static Future<int> getTotalWordCount();

  /// 近 N 天每日阅读量（折线图数据）
  static Future<List<DailyStat>> getDailyTrend(int days);

  /// 新闻 vs 博客分布（饼图数据）
  static Future<List<TypeStat>> getTypeDistribution();
}

class DailyStat {
  final String date;   // "06-01"
  final int count;     // 篇数
  final int wordCount; // 字数
}

class TypeStat {
  final String type;   // "news" | "blog"
  final int count;
}
```

## Controller 层

### OfflineCacheController

```dart
class OfflineCacheController extends GetxController {
  final cachedKeys = <String>{}.obs;       // "news_123", "blog_456"
  final cacheSizeBytes = 0.obs;

  Future<void> refreshCachedKeys();
  bool isCached(String type, int id) => cachedKeys.contains('${type}_$id');
  Future<void> clearCache();
  Future<void> refreshCacheSize();
}
```

### ReadingStatsController

```dart
class ReadingStatsController extends GetxController {
  final todayCount = 0.obs;
  final totalCount = 0.obs;
  final todayWords = 0.obs;
  final totalWords = 0.obs;
  final dailyTrend = <DailyStat>[].obs;
  final typeDist = <TypeStat>[].obs;

  Future<void> refresh();
}
```

## UI 改动细节

### 详情页自动缓存 + 记录阅读

在 `news_detail_page.dart` / `blog_detail_page.dart` 的 `_initData()` 成功获取数据后：

```dart
// 获取详情成功后
final wordCount = PassageUtils.countReadableChars(newsDetail.body);
await CacheDao.insert(
  type: 'news',  // 或 'blog'
  id: newsDetail.id,
  title: newsDetail.title,
  author: newsDetail.author,
  pubDate: newsDetail.pubDate,
  body: newsDetail.body,
);
await ReadHistoryDao.recordRead(
  type: 'news',
  id: newsDetail.id,
  title: newsDetail.title,
  wordCount: wordCount,
);
// 触发图片下载
final imageUrls = PassageUtils.extractImageUrls(newsDetail.body);
if (imageUrls.isNotEmpty) {
  ImageDownloadService.instance.enqueueImageDownloads('news_${newsDetail.id}', imageUrls);
}
```

### 字数统计函数

```dart
// lib/utils/passage_utils.dart — 新增方法
static int countReadableChars(String htmlOrMarkdown) {
  final stripped = htmlOrMarkdown.replaceAll(RegExp(r'<[^>]*>'), '');
  // 用正则去掉 <img> 等标签的 alt 文本？不，alt 文本也算"阅读内容"
  return stripped.replaceAll(RegExp(r'\s'), '').length;
}

static List<String> extractImageUrls(String html) {
  final regex = RegExp(r'<img[^>]+src="([^">]+)"');
  return regex.allMatches(html).map((m) => m.group(1)!).toList();
}
```

### 卡片右上角"已缓存"标记

在 `staggered_news_card.dart` / `staggered_blog_card.dart` 的 Column 顶部 `Row` 中，左上角是 type 标签，右上角增加条件渲染的"已缓存"标签：

```dart
// 在 Row 中使用 Spacer() 将 type 标签和缓存标签拉到两端
Row(
  children: [
    // 原有的 type 标签
    _buildTypeBadge(),
    const Spacer(),
    // 新增：已缓存标签
    if (Get.find<OfflineCacheController>()
        .isCached('news', news.id))  // 或 'blog', blog.id
      _buildCachedBadge(),
  ],
)
```

### 列表页返回后刷新

在 `news_tab.dart` / `blog_tab.dart` 中的导航回调：

```dart
// 跳转到详情页
Get.to(() => NewsDetailPage(newsId: news.id)).then((_) {
  Get.find<OfflineCacheController>().refreshCachedKeys();
});
```

### 设置页缓存管理

在 `settings_page.dart` 新增"缓存管理"分组，展示缓存大小和清除按钮。

### 统计页面

`stats_page.dart` — 使用 `fl_chart` 展示：
1. 顶部：今日阅读（篇数 + 字数）、累计（篇数 + 字数）
2. 折线图：近 7 天阅读字数趋势
3. 饼图或条形图：新闻 vs 博客分布

## 离线渲染逻辑

```dart
// 打开缓存的文章（无网络时）
final cached = await CacheDao.get(type, id);
String body = cached.localBody ?? cached.body;
// localBody 中的图片已替换为 file:// 路径（已完成下载的）
// 未完成下载的保留原始 URL
// WebView 加载时: file:// 路径离线也可显示
//                 https:// 路径在线时可显示，离线时留空
```

## 字数统计说明

- 去掉 HTML 标签后统计所有非空白字符数
- 中文：一个字算 1 字符
- 英文：每个字母算 1 字符（含标点）
- 去掉了 `<img>` 标签本身，但不去掉 alt 文本（也是阅读内容）

## 启动初始化

在 `main.dart` 的 App 初始化时：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;     // 初始化 sqflite
  await ImageDownloadService.instance.init();  // 启动任务队列
  runApp(const MyApp());
}
```

## 依赖包

| 包 | 用途 |
|----|------|
| `sqflite: ^2.4.0` | 本地 SQLite 数据库 |
| `path_provider: ^2.1.0` | 获取 App 文档目录（存图片） |
| `fl_chart: ^0.70.0` | 统计图表（折线图 + 饼图） |
| `crypto: ^3.0.0` | MD5 哈希（图片文件名去重） |
| `path: ^1.9.0` | 文件路径拼接（已隐含依赖） |