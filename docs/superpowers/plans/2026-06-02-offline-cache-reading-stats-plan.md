# 离线缓存 + 阅读统计 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 实现离线缓存（含图片预下载）+ 阅读统计（篇数、字数、趋势图表）

**Architecture:** sqflite 3 表（cache_items, image_cache, read_history）+ APP 级图片下载任务队列 + GetX 控制器响应式绑定 + fl_chart 图表

**Tech Stack:** sqflite, path_provider, fl_chart, crypto, Dio

---

## 文件清单

### 新建 (7 个)

| 文件 | 职责 |
|------|------|
| `lib/database/database_helper.dart` | sqflite 单例初始化 + 建表 |
| `lib/database/cache_dao.dart` | 缓存 CRUD + image_cache 联合操作 |
| `lib/database/read_history_dao.dart` | 阅读记录 + 统计聚合查询 |
| `lib/utils/image_download_service.dart` | APP 级任务队列：图片下载、本地存储 |
| `lib/controllers/offline_cache_controller.dart` | GetX: 缓存状态响应式管理 |
| `lib/controllers/reading_stats_controller.dart` | GetX: 阅读统计响应式管理 |
| `lib/pages/stats_page.dart` | 阅读统计页面（fl_chart 折线图 + 饼图） |

### 修改 (12 个)

| 文件 | 说明 |
|------|------|
| `pubspec.yaml` | 新增 sqflite, path_provider, fl_chart, crypto |
| `lib/main.dart` | 初始化 DatabaseHelper + ImageDownloadService |
| `lib/utils/passage_utils.dart` | 新增 countReadableChars() + extractImageUrls() |
| `lib/pages/news_detail_page.dart` | 成功后自动缓存 + 记录阅读 |
| `lib/pages/blog_detail_page.dart` | 同上 |
| `lib/pages/news_tab.dart` | 返回列表时刷新缓存状态 |
| `lib/pages/blog_tab.dart` | 同上 |
| `lib/pages/settings_page.dart` | 新增"缓存管理"分组（大小 + 清除） |
| `lib/widgets/staggered_news_card.dart` | 右上角"已缓存"标记 |
| `lib/widgets/staggered_blog_card.dart` | 右上角"已缓存"标记 |
| `lib/pages/account_page.dart` | 新增"阅读统计"入口按钮 |

---

### Task 1: 添加 sqflite / path_provider / fl_chart / crypto 依赖

**Files:**
- Modify: `news_check_app/pubspec.yaml`

- [ ] **Step 1: 在 pubspec.yaml 的 dependencies 中添加四个包**

在 `pubspec.yaml` 的 dependencies 区块末尾、dev_dependencies 之前添加：

```yaml
dependencies:
  # ... 现有依赖 ...
  sqflite: ^2.4.0
  path_provider: ^2.1.0
  fl_chart: ^0.70.0
  crypto: ^3.0.0
```

- [ ] **Step 2: 运行 flutter pub get**

```bash
cd backend/../news_check_app && flutter pub get
```

Expected: 四个包下载成功，无错误。

- [ ] **Step 3: Commit**

```bash
git add news_check_app/pubspec.yaml news_check_app/pubspec.lock
git commit -m "chore: add sqflite, path_provider, fl_chart, crypto dependencies"
```

---

### Task 2: 创建 database_helper.dart — sqflite 单例 + 建表

**Files:**
- Create: `news_check_app/lib/database/database_helper.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'news_check.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // cache_items: 缓存文章详情
    await db.execute('''
      CREATE TABLE cache_items (
        item_type TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        pub_date TEXT NOT NULL,
        body TEXT NOT NULL,
        local_body TEXT,
        cached_at INTEGER NOT NULL,
        PRIMARY KEY (item_type, item_id)
      )
    ''');

    // image_cache: 图片下载状态
    await db.execute('''
      CREATE TABLE image_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cache_key TEXT NOT NULL,
        original_url TEXT NOT NULL,
        local_path TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        UNIQUE(cache_key, original_url)
      )
    ''');

    // read_history: 阅读历史
    await db.execute('''
      CREATE TABLE read_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_type TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        word_count INTEGER NOT NULL,
        read_at INTEGER NOT NULL
      )
    ''');

    // 索引：按时间查询阅读记录
    await db.execute('CREATE INDEX idx_read_history_read_at ON read_history(read_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 预留迁移入口
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/database/database_helper.dart
git commit -m "feat: add DatabaseHelper sqflite singleton with 3 tables"
```

---

### Task 3: 创建 cache_dao.dart — 缓存 CRUD + image_cache 联合操作

**Files:**
- Create: `news_check_app/lib/database/cache_dao.dart`
- Modify: `news_check_app/lib/database/database_helper.dart` (新增 import)

- [ ] **Step 1: 创建 cache_dao.dart**

```dart
import 'dart:io';

import 'package:news_check_app/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CacheItem {
  final String itemType;
  final int itemId;
  final String title;
  final String author;
  final String pubDate;
  final String body;
  final String? localBody;
  final int cachedAt;

  CacheItem({
    required this.itemType,
    required this.itemId,
    required this.title,
    required this.author,
    required this.pubDate,
    required this.body,
    this.localBody,
    required this.cachedAt,
  });

  factory CacheItem.fromMap(Map<String, dynamic> map) {
    return CacheItem(
      itemType: map['item_type'] as String,
      itemId: map['item_id'] as int,
      title: map['title'] as String,
      author: map['author'] as String,
      pubDate: map['pub_date'] as String,
      body: map['body'] as String,
      localBody: map['local_body'] as String?,
      cachedAt: map['cached_at'] as int,
    );
  }
}

class CacheDao {
  static Database get _db => DatabaseHelper.instance.database as Database;

  /// 获取 Database 实例
  static Future<Database> _getDb() => DatabaseHelper.instance.database;

  /// 缓存文章（UPSERT 语义：存在则更新 cached_at，body 不变则跳过）
  static Future<void> insert({
    required String type,
    required int id,
    required String title,
    required String author,
    required String pubDate,
    required String body,
  }) async {
    final db = await _getDb();
    await db.insert(
      'cache_items',
      {
        'item_type': type,
        'item_id': id,
        'title': title,
        'author': author,
        'pub_date': pubDate,
        'body': body,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 检查某文章是否已缓存
  static Future<bool> exists(String type, int id) async {
    final db = await _getDb();
    final result = await db.query(
      'cache_items',
      columns: ['item_type'],
      where: 'item_type = ? AND item_id = ?',
      whereArgs: [type, id],
    );
    return result.isNotEmpty;
  }

  /// 获取缓存文章详情
  static Future<CacheItem?> get(String type, int id) async {
    final db = await _getDb();
    final result = await db.query(
      'cache_items',
      where: 'item_type = ? AND item_id = ?',
      whereArgs: [type, id],
    );
    if (result.isEmpty) return null;
    return CacheItem.fromMap(result.first);
  }

  /// 获取所有已缓存文章的 "type_id" 集合
  static Future<Set<String>> getAllKeys() async {
    final db = await _getDb();
    final result = await db.query('cache_items', columns: ['item_type', 'item_id']);
    return result.map((row) => '${row['item_type']}_${row['item_id']}').toSet();
  }

  /// 删除单条缓存（含关联的 image_cache 记录）
  static Future<void> delete(String type, int id) async {
    final db = await _getDb();
    final cacheKey = '${type}_$id';
    // 删除关联的图片记录
    await db.delete('image_cache', where: 'cache_key = ?', whereArgs: [cacheKey]);
    // 删除缓存记录
    await db.delete('cache_items', where: 'item_type = ? AND item_id = ?', whereArgs: [type, id]);
  }

  /// 清空所有缓存（含图片表 + 本地图片文件）
  static Future<void> clearAll() async {
    final db = await _getDb();
    // 获取所有已下载的图片路径
    final images = await db.query(
      'image_cache',
      columns: ['local_path'],
      where: 'status = ?',
      whereArgs: ['completed'],
    );
    // 删除本地图片文件
    for (final img in images) {
      final path = img['local_path'] as String?;
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    // 清空表
    await db.delete('image_cache');
    await db.delete('cache_items');
  }

  /// 统计缓存数据大小（数据库行 + 图片文件）
  static Future<int> getTotalSize() async {
    final db = await _getDb();
    // 数据库文件大小
    final dbPath = await db.getPath();
    final dbFile = File(dbPath);
    int total = 0;
    if (await dbFile.exists()) {
      total += await dbFile.length();
    }
    // 图片文件大小
    final images = await db.query(
      'image_cache',
      columns: ['local_path'],
      where: 'status = ? AND local_path IS NOT NULL',
      whereArgs: ['completed'],
    );
    for (final img in images) {
      final path = img['local_path'] as String?;
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          total += await file.length();
        }
      }
    }
    return total;
  }

  // ---- image_cache 操作方法 ----

  /// 批量插入图片下载任务
  static Future<void> insertImageTasks(String cacheKey, List<String> imageUrls) async {
    final db = await _getDb();
    final batch = db.batch();
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final url in imageUrls) {
      batch.insert(
        'image_cache',
        {
          'cache_key': cacheKey,
          'original_url': url,
          'status': 'pending',
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  /// 获取待下载的图片任务
  static Future<List<Map<String, dynamic>>> getPendingImageTasks({int limit = 10}) async {
    final db = await _getDb();
    return db.query(
      'image_cache',
      where: 'status = ?',
      whereArgs: ['pending'],
      limit: limit,
    );
  }

  /// 更新图片下载状态
  static Future<void> updateImageStatus(int id, String status, {String? localPath}) async {
    final db = await _getDb();
    await db.update(
      'image_cache',
      {
        'status': status,
        if (localPath != null) 'local_path': localPath,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 获取某文章所有图片的下载状态
  static Future<List<Map<String, dynamic>>> getImageStatuses(String cacheKey) async {
    final db = await _getDb();
    return db.query(
      'image_cache',
      where: 'cache_key = ?',
      whereArgs: [cacheKey],
    );
  }

  /// 更新 local_body：将已完成下载的图片 URL 替换为本地路径
  static Future<void> updateLocalBody(String cacheKey) async {
    final db = await _getDb();
    final parts = cacheKey.split('_');
    if (parts.length < 2) return;
    final type = parts[0];
    final id = int.tryParse(parts[1]);
    if (id == null) return;

    // 获取原 body
    final item = await db.query(
      'cache_items',
      columns: ['body', 'local_body'],
      where: 'item_type = ? AND item_id = ?',
      whereArgs: [type, id],
    );
    if (item.isEmpty) return;

    String body = item.first['local_body'] as String? ?? item.first['body'] as String;

    // 获取所有已完成的图片
    final completed = await db.query(
      'image_cache',
      columns: ['original_url', 'local_path'],
      where: 'cache_key = ? AND status = ? AND local_path IS NOT NULL',
      whereArgs: [cacheKey, 'completed'],
    );

    for (final img in completed) {
      final originalUrl = img['original_url'] as String;
      final localPath = img['local_path'] as String;
      body = body.replaceAll(originalUrl, localPath);
    }

    // 更新 local_body
    await db.update(
      'cache_items',
      {'local_body': body},
      where: 'item_type = ? AND item_id = ?',
      whereArgs: [type, id],
    );
  }

  /// 统计未完成的任务数量
  static Future<int> getPendingTaskCount() async {
    final db = await _getDb();
    final result = await db.query(
      'image_cache',
      columns: ['id'],
      where: 'status = ? OR status = ?',
      whereArgs: ['pending', 'downloading'],
    );
    return result.length;
  }

  /// 按 cacheKey 查询待下载的任务（获取真实 DB id）
  static Future<List<Map<String, dynamic>>> getPendingTasksByCacheKey(String cacheKey) async {
    final db = await _getDb();
    return db.query(
      'image_cache',
      where: 'cache_key = ? AND status = ?',
      whereArgs: [cacheKey, 'pending'],
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/database/cache_dao.dart
git commit -m "feat: add CacheDao with image_cache operations"
```

---

### Task 4: 创建 read_history_dao.dart — 阅读记录 + 统计查询

**Files:**
- Create: `news_check_app/lib/database/read_history_dao.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'package:news_check_app/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class DailyStat {
  final String date;
  final int count;
  final int wordCount;
  DailyStat({required this.date, required this.count, required this.wordCount});
}

class TypeStat {
  final String type;
  final int count;
  TypeStat({required this.type, required this.count});
}

class ReadHistoryDao {
  static Future<Database> _getDb() => DatabaseHelper.instance.database;

  /// 记录一次阅读
  static Future<void> recordRead({
    required String type,
    required int id,
    required String title,
    required int wordCount,
  }) async {
    final db = await _getDb();
    await db.insert('read_history', {
      'item_type': type,
      'item_id': id,
      'title': title,
      'word_count': wordCount,
      'read_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 今日阅读篇数
  static Future<int> getTodayCount() async {
    final db = await _getDb();
    final startOfDay = DateTime.now().copyWith(
      hour: 0, minute: 0, second: 0, millisecond: 0,
    ).millisecondsSinceEpoch;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM read_history WHERE read_at >= ?',
      [startOfDay],
    );
    return (result.first['cnt'] as int?) ?? 0;
  }

  /// 累计阅读篇数
  static Future<int> getTotalCount() async {
    final db = await _getDb();
    final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM read_history');
    return (result.first['cnt'] as int?) ?? 0;
  }

  /// 今日阅读字数
  static Future<int> getTodayWordCount() async {
    final db = await _getDb();
    final startOfDay = DateTime.now().copyWith(
      hour: 0, minute: 0, second: 0, millisecond: 0,
    ).millisecondsSinceEpoch;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(word_count), 0) as total FROM read_history WHERE read_at >= ?',
      [startOfDay],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  /// 累计阅读字数
  static Future<int> getTotalWordCount() async {
    final db = await _getDb();
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(word_count), 0) as total FROM read_history',
    );
    return (result.first['total'] as int?) ?? 0;
  }

  /// 近 N 天每日阅读量
  static Future<List<DailyStat>> getDailyTrend(int days) async {
    final db = await _getDb();
    final threshold = DateTime.now().subtract(Duration(days: days - 1))
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    final result = await db.rawQuery('''
      SELECT
        DATE(read_at / 1000, 'unixepoch', 'localtime') as date,
        COUNT(*) as cnt,
        COALESCE(SUM(word_count), 0) as total_words
      FROM read_history
      WHERE read_at >= ?
      GROUP BY date
      ORDER BY date ASC
    ''', [threshold.millisecondsSinceEpoch]);

    // 填充没有阅读记录的日期
    final dateMap = <String, DailyStat>{};
    for (final row in result) {
      dateMap[row['date'] as String] = DailyStat(
        date: row['date'] as String,
        count: (row['cnt'] as int?) ?? 0,
        wordCount: (row['total_words'] as int?) ?? 0,
      );
    }

    final trend = <DailyStat>[];
    for (int i = days - 1; i >= 0; i--) {
      final d = DateTime.now().subtract(Duration(days: i));
      final dateStr = '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      trend.add(dateMap[dateStr] ?? DailyStat(date: dateStr, count: 0, wordCount: 0));
    }
    return trend;
  }

  /// 新闻 vs 博客分布
  static Future<List<TypeStat>> getTypeDistribution() async {
    final db = await _getDb();
    final result = await db.rawQuery('''
      SELECT item_type, COUNT(*) as cnt
      FROM read_history
      GROUP BY item_type
      ORDER BY cnt DESC
    ''');
    return result.map((row) => TypeStat(
      type: row['item_type'] as String,
      count: (row['cnt'] as int?) ?? 0,
    )).toList();
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/database/read_history_dao.dart
git commit -m "feat: add ReadHistoryDao with daily stats queries"
```

---

### Task 5: 创建 image_download_service.dart — APP 级图片下载任务队列

**Files:**
- Create: `news_check_app/lib/utils/image_download_service.dart`

- [ ] **Step 1: 创建文件**

```dart
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:news_check_app/database/cache_dao.dart';
import 'package:path_provider/path_provider.dart';

class _DownloadTask {
  final int id;
  final String cacheKey;
  final String url;
  int retryCount;

  _DownloadTask({
    required this.id,
    required this.cacheKey,
    required this.url,
    this.retryCount = 0,
  });
}

class ImageDownloadService {
  ImageDownloadService._();
  static final ImageDownloadService instance = ImageDownloadService._();

  final Dio _dio = Dio();
  final _queue = <_DownloadTask>[];
  int _activeCount = 0;
  bool _running = false;
  bool _disposed = false;

  static const int _maxConcurrent = 3;
  static const int _maxRetries = 2;

  /// 初始化：检查未完成的任务，重新入队
  Future<void> init() async {
    if (_running) return;
    _running = true;
    _disposed = false;
    // 恢复 pending 和 downloading 的任务
    final pending = await CacheDao.getPendingImageTasks(limit: 100);
    for (final task in pending) {
      // 将 downloading 状态重置为 pending
      if (task['status'] == 'downloading') {
        await CacheDao.updateImageStatus(task['id'] as int, 'pending');
      }
      _queue.add(_DownloadTask(
        id: task['id'] as int,
        cacheKey: task['cache_key'] as String,
        url: task['original_url'] as String,
      ));
    }
    _processQueue();
  }

  /// 为文章添加图片下载任务（fire-and-forget，非阻塞）
  void enqueueImageDownloads(String cacheKey, List<String> imageUrls) {
    if (imageUrls.isEmpty) return;
    // 异步插入数据库后查询真实 id 再入队
    _insertAndEnqueue(cacheKey, imageUrls);
  }

  Future<void> _insertAndEnqueue(String cacheKey, List<String> imageUrls) async {
    await CacheDao.insertImageTasks(cacheKey, imageUrls);
    final tasks = await CacheDao.getPendingTasksByCacheKey(cacheKey);
    for (final t in tasks) {
      final url = t['original_url'] as String;
      if (!_queue.any((qt) => qt.cacheKey == cacheKey && qt.url == url)) {
        _queue.add(_DownloadTask(
          id: t['id'] as int,
          cacheKey: t['cache_key'] as String,
          url: url,
        ));
      }
    }
    _processQueue();
  }

  void pause() {
    _running = false;
  }

  void resume() {
    if (_running || _disposed) return;
    _running = true;
    _processQueue();
  }

  void dispose() {
    _disposed = true;
    _running = false;
    _queue.clear();
  }

  /// 生成唯一文件名
  String _hashUrl(String url) {
    final bytes = utf8.encode(url);
    return md5.convert(bytes).toString();
  }

  Future<String> _getImageDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/.cache_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir.path;
  }

  Future<void> _processQueue() async {
    if (_disposed) return;
    while (_running && _queue.isNotEmpty && _activeCount < _maxConcurrent) {
      final task = _queue.removeAt(0);
      _activeCount++;
      _downloadImage(task).then((_) {
        _activeCount--;
        _processQueue();
      });
    }
  }

  Future<void> _downloadImage(_DownloadTask task) async {
    try {
      // 标记为 downloading
      await CacheDao.updateImageStatus(task.id, 'downloading');

      final imageDir = await _getImageDir();
      final ext = _guessExtension(task.url);
      final fileName = '${_hashUrl(task.url)}$ext';
      final filePath = '$imageDir/$fileName';

      // 检查是否已下载
      final file = File(filePath);
      if (await file.exists()) {
        // 已存在，直接标记完成
        await CacheDao.updateImageStatus(task.id, 'completed', localPath: filePath);
        await CacheDao.updateLocalBody(task.cacheKey);
        return;
      }

      // 下载
      await _dio.download(task.url, filePath);

      // 验证文件是否有效
      if (await file.exists() && await file.length() > 0) {
        await CacheDao.updateImageStatus(task.id, 'completed', localPath: filePath);
      } else {
        // 下载成功但文件无效，删除重试
        if (await file.exists()) await file.delete();
        throw Exception('Downloaded file is empty');
      }

      // 更新 local_body
      await CacheDao.updateLocalBody(task.cacheKey);
    } catch (e) {
      if (task.retryCount < _maxRetries) {
        task.retryCount++;
        await CacheDao.updateImageStatus(task.id, 'pending');
        // 重新入队
        _queue.add(task);
      } else {
        await CacheDao.updateImageStatus(task.id, 'failed');
      }
    }
  }

  String _guessExtension(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '.jpg';
    final path = uri.path;
    final ext = path.split('.').last;
    final known = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'];
    if (known.contains(ext.toLowerCase())) {
      return '.${ext.toLowerCase()}';
    }
    return '.jpg'; // 默认
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/utils/image_download_service.dart
git commit -m "feat: add ImageDownloadService app-level task queue"
```

---

### Task 6: 修改 passage_utils.dart — 新增 countReadableChars() + extractImageUrls()

**Files:**
- Modify: `news_check_app/lib/utils/passage_utils.dart`

- [ ] **Step 1: 在 PassageUtils 类中添加两个新方法**

```dart
  /// 统计有效阅读字符数（去掉 HTML 标签后的非空白字符）
  static int countReadableChars(String htmlOrMarkdown) {
    final stripped = htmlOrMarkdown.replaceAll(RegExp(r'<[^>]*>'), '');
    return stripped.replaceAll(RegExp(r'\s'), '').length;
  }

  /// 从 HTML 中提取所有图片 URL
  static List<String> extractImageUrls(String html) {
    final regex = RegExp(r'<img[^>]+src="([^">]+)"');
    return regex.allMatches(html).map((m) => m.group(1)!).toList();
  }
```

添加到 `class PassageUtils { ... }` 的末尾（`imageClickJs` 常量之前）。

- [ ] **Step 2: Commit**

```bash
git add news_check_app/lib/utils/passage_utils.dart
git commit -m "feat: add countReadableChars() and extractImageUrls()"
```

---

### Task 7: 创建 OfflineCacheController + ReadingStatsController

**Files:**
- Create: `news_check_app/lib/controllers/offline_cache_controller.dart`
- Create: `news_check_app/lib/controllers/reading_stats_controller.dart`

- [ ] **Step 1: 创建 offline_cache_controller.dart**

```dart
import 'package:get/get.dart';
import 'package:news_check_app/database/cache_dao.dart';

class OfflineCacheController extends GetxController {
  final cachedKeys = <String>{}.obs;
  final cacheSizeBytes = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshCachedKeys();
    refreshCacheSize();
  }

  Future<void> refreshCachedKeys() async {
    cachedKeys.value = await CacheDao.getAllKeys();
  }

  bool isCached(String type, int id) => cachedKeys.contains('${type}_$id');

  Future<void> refreshCacheSize() async {
    cacheSizeBytes.value = await CacheDao.getTotalSize();
  }

  Future<void> clearCache() async {
    await CacheDao.clearAll();
    await refreshCachedKeys();
    await refreshCacheSize();
  }
}
```

- [ ] **Step 2: 创建 reading_stats_controller.dart**

```dart
import 'package:get/get.dart';
import 'package:news_check_app/database/read_history_dao.dart';

class ReadingStatsController extends GetxController {
  final todayCount = 0.obs;
  final totalCount = 0.obs;
  final todayWords = 0.obs;
  final totalWords = 0.obs;
  final dailyTrend = <DailyStat>[].obs;
  final typeDist = <TypeStat>[].obs;

  Future<void> refresh() async {
    todayCount.value = await ReadHistoryDao.getTodayCount();
    totalCount.value = await ReadHistoryDao.getTotalCount();
    todayWords.value = await ReadHistoryDao.getTodayWordCount();
    totalWords.value = await ReadHistoryDao.getTotalWordCount();
    dailyTrend.value = await ReadHistoryDao.getDailyTrend(7);
    typeDist.value = await ReadHistoryDao.getTypeDistribution();
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/controllers/offline_cache_controller.dart
git add news_check_app/lib/controllers/reading_stats_controller.dart
git commit -m "feat: add OfflineCacheController and ReadingStatsController"
```

---

### Task 8: 详情页自动缓存 + 记录阅读

**Files:**
- Modify: `news_check_app/lib/pages/news_detail_page.dart`
- Modify: `news_check_app/lib/pages/blog_detail_page.dart`

- [ ] **Step 1: 在 news_detail_page.dart 的 _initData() 中，获取详情成功后添加缓存 + 记录阅读**

在 `setState(() { _detail = newsDetail; });` 之前添加：

```dart
                      // 自动缓存
                      final wordCount = PassageUtils.countReadableChars(newsDetail.body);
                      await CacheDao.insert(
                        type: 'news',
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
                        ImageDownloadService.instance
                            .enqueueImageDownloads('news_${newsDetail.id}', imageUrls);
                      }
```

同时添加 import：

```dart
import 'package:news_check_app/database/cache_dao.dart';
import 'package:news_check_app/database/read_history_dao.dart';
import 'package:news_check_app/utils/image_download_service.dart';
```

- [ ] **Step 2: 同样修改 blog_detail_page.dart**

在 `setState(() { _detail = blogDetail; });` 前添加（注意 type 是 'blog'）：

```dart
                      final wordCount = PassageUtils.countReadableChars(blogDetail.body);
                      await CacheDao.insert(
                        type: 'blog',
                        id: blogDetail.id,
                        title: blogDetail.title,
                        author: blogDetail.author,
                        pubDate: blogDetail.pubDate,
                        body: blogDetail.body,
                      );
                      await ReadHistoryDao.recordRead(
                        type: 'blog',
                        id: blogDetail.id,
                        title: blogDetail.title,
                        wordCount: wordCount,
                      );
                      final imageUrls = PassageUtils.extractImageUrls(blogDetail.body);
                      if (imageUrls.isNotEmpty) {
                        ImageDownloadService.instance
                            .enqueueImageDownloads('blog_${blogDetail.id}', imageUrls);
                      }
```

添加相同 import。

- [ ] **Step 3: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "error"
```

Expected: 0 errors

- [ ] **Step 4: Commit**

```bash
git add news_check_app/lib/pages/news_detail_page.dart news_check_app/lib/pages/blog_detail_page.dart
git commit -m "feat: auto-cache article and record reading on detail page load"
```

---

### Task 9: 卡片右上角"已缓存"标记

**Files:**
- Modify: `news_check_app/lib/widgets/staggered_news_card.dart`
- Modify: `news_check_app/lib/widgets/staggered_blog_card.dart`

- [ ] **Step 1: 在 staggered_news_card.dart 的 Row 中 type 标签右侧添加 "已缓存" 标记**

在 Row 的 `children` 中，`_blogTypeLabel(blog.type)` 标签的 `Container` 之后、`const SizedBox(height: 8)` 之前：

```dart
            Row(
              children: [
                // 类型标签
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: textColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _newsTypeLabel(news.type),
                    style: TextStyle(...),
                  ),
                ),
                const Spacer(),
                // 已缓存标记
                if (Get.find<OfflineCacheController>().isCached('news', news.id))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(200),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '已缓存',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
```

同时在文件顶部添加 import：

```dart
import 'package:news_check_app/controllers/offline_cache_controller.dart';
```

- [ ] **Step 2: 同样修改 staggered_blog_card.dart**

在类型标签 Row 中的 `Spacer()` 之后添加相同的 "已缓存" Container，使用 `blog.id` 调用 `isCached('blog', blog.id)`。

同样添加 import。注意 blog card 的 StaggeredBlogCard 接收的是 `BlogSimple blog`，其 `type` 为 int，`id` 也为 int，直接使用 `isCached('blog', blog.id)`。

- [ ] **Step 3: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "error"
```

Expected: 0 errors

- [ ] **Step 4: Commit**

```bash
git add news_check_app/lib/widgets/staggered_news_card.dart news_check_app/lib/widgets/staggered_blog_card.dart
git commit -m "feat: add offline cache badge on card top-right"
```

---

### Task 10: 列表页返回时刷新缓存状态

**Files:**
- Modify: `news_check_app/lib/pages/news_tab.dart`
- Modify: `news_check_app/lib/pages/blog_tab.dart`

- [ ] **Step 1: 在 news_tab.dart 中找到导航到详情页的代码，添加 .then() 回调**

假设现有的导航代码为 `Get.to(() => NewsDetailPage(newsId: news.id))`，修改为：

```dart
Get.to(() => NewsDetailPage(newsId: news.id)).then((_) {
  if (mounted) {
    Get.find<OfflineCacheController>().refreshCachedKeys();
  }
});
```

并添加 import：

```dart
import 'package:news_check_app/controllers/offline_cache_controller.dart';
```

- [ ] **Step 2: 同样修改 blog_tab.dart**

```dart
Get.to(() => BlogDetailPage(blogId: blog.id)).then((_) {
  if (mounted) {
    Get.find<OfflineCacheController>().refreshCachedKeys();
  }
});
```

同样添加 import。

- [ ] **Step 3: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "error"
```

Expected: 0 errors

- [ ] **Step 4: Commit**

```bash
git add news_check_app/lib/pages/news_tab.dart news_check_app/lib/pages/blog_tab.dart
git commit -m "feat: refresh cache badges when returning from detail page"
```

---

### Task 11: 设置页添加缓存管理

**Files:**
- Modify: `news_check_app/lib/pages/settings_page.dart`

- [ ] **Step 1: 在 settings_page.dart 的 Column 中添加"缓存管理"分组**

在主题设置的 `Padding` 和 `SettingItemGroup` 之后，Column 的 `children` 中添加：

```dart
            _buildSettingGroupTitle("缓存管理"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Obx(() {
                final cacheCtrl = Get.find<OfflineCacheController>();
                final sizeMB = (cacheCtrl.cacheSizeBytes.value / (1024 * 1024)).toStringAsFixed(1);
                return SettingItemGroup(
                  settingItems: [
                    SettingItem(
                      title: Text("缓存数据"),
                      tail: Text("$sizeMB MB"),
                    ),
                    SettingItem(
                      title: Text("清除缓存"),
                      tail: TextButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("清除缓存"),
                              content: const Text("确定要清除所有离线缓存数据吗？\n包括已下载的图片。"),
                              actions: [
                                TextButton(onPressed: () => Get.back(result: false), child: const Text("取消")),
                                TextButton(onPressed: () => Get.back(result: true), child: const Text("确定")),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await cacheCtrl.clearCache();
                            if (context.mounted) {
                              Fluttertoast.showToast(msg: "缓存已清除");
                            }
                          }
                        },
                        child: const Text("清除缓存"),
                      ),
                    ),
                  ],
                );
              }),
            ),
```

同时在文件顶部添加 import：

```dart
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_check_app/controllers/offline_cache_controller.dart';
```

- [ ] **Step 2: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "error"
```

Expected: 0 errors

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/pages/settings_page.dart
git commit -m "feat: add cache management section in settings page"
```

---

### Task 12: 创建 stats_page.dart + 账户页入口

**Files:**
- Create: `news_check_app/lib/pages/stats_page.dart`
- Modify: `news_check_app/lib/pages/account_page.dart`

- [ ] **Step 1: 创建 stats_page.dart**

```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/reading_stats_controller.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final _controller = Get.isRegistered<ReadingStatsController>()
      ? Get.find<ReadingStatsController>()
      : Get.put(ReadingStatsController());

  @override
  void initState() {
    super.initState();
    _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("阅读统计")),
      body: RefreshIndicator(
        onRefresh: () => _controller.refresh(),
        displacement: 80,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 今日统计卡片
                _buildStatCard(
                  icon: Icons.today,
                  title: "今日阅读",
                  subtitle: "${_controller.todayCount.value} 篇 · ${_formatWords(_controller.todayWords.value)} 字",
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                // 累计统计卡片
                _buildStatCard(
                  icon: Icons.auto_stories,
                  title: "累计阅读",
                  subtitle: "${_controller.totalCount.value} 篇 · ${_formatWords(_controller.totalWords.value)} 字",
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 24),
                // 折线图
                Text("近 7 天阅读趋势", style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildLineChart(),
                ),
                const SizedBox(height: 24),
                // 类型分布
                Text("内容类型分布", style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildPieChart(),
                ),
                const SizedBox(height: 16),
                // 类型分布文字说明
                if (_controller.typeDist.isNotEmpty)
                  ..._controller.typeDist.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 12, height: 12,
                          decoration: BoxDecoration(
                            color: _typeColor(t.type),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(t.type == 'news' ? '新闻' : '博客'),
                        const Spacer(),
                        Text("${t.count} 篇"),
                      ],
                    ),
                  )),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  String _formatWords(int words) {
    if (words >= 10000) {
      return '${(words / 10000).toStringAsFixed(1)}w';
    } else if (words >= 1000) {
      return '${(words / 1000).toStringAsFixed(1)}k';
    }
    return '$words';
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'news': return const Color(0xFF0D9488);
      case 'blog': return const Color(0xFF7C3AED);
      default: return Colors.grey;
    }
  }

  Widget _buildLineChart() {
    if (_controller.dailyTrend.isEmpty) {
      return const Center(child: Text("暂无数据"));
    }
    final spots = _controller.dailyTrend.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.wordCount.toDouble());
    }).toList();

    final maxY = _controller.dailyTrend
        .fold<int>(0, (max, s) => s.wordCount > max ? s.wordCount : max)
        .toDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? (maxY / 4).ceilToDouble().clamp(1, maxY) : 1,
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= _controller.dailyTrend.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _controller.dailyTrend[i].date,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF0D9488),
            barWidth: 2.5,
            dotData: FlDotData(
              show: spots.length <= 8,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: const Color(0xFF0D9488),
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF0D9488).withAlpha(30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    if (_controller.typeDist.isEmpty) {
      return const Center(child: Text("暂无数据"));
    }
    return PieChart(
      PieChartData(
        sections: _controller.typeDist.asMap().entries.map((e) {
          final isLast = e.key == _controller.typeDist.length - 1;
          return PieChartSectionData(
            value: e.value.count.toDouble(),
            title: '${e.value.count}',
            color: _typeColor(e.value.type),
            radius: isLast ? 55 : 50,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}
```

- [ ] **Step 2: 在 account_page.dart 中添加"阅读统计"入口按钮**

找到账户页的 ListTile 列表区，在"我的收藏"或"设置"等按钮旁边添加：

```dart
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("阅读统计"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.to(() => const StatsPage()),
            ),
```

同时在文件顶部添加 import：

```dart
import 'package:news_check_app/pages/stats_page.dart';
```

- [ ] **Step 3: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "error"
```

Expected: 0 errors

- [ ] **Step 4: Commit**

```bash
git add news_check_app/lib/pages/stats_page.dart news_check_app/lib/pages/account_page.dart
git commit -m "feat: add reading stats page with charts and account entry"
```

---

### Task 13: 初始化 DatabaseHelper + ImageDownloadService 在 main.dart 中

**Files:**
- Modify: `news_check_app/lib/main.dart`

- [ ] **Step 1: 在 main() 函数中添加初始化，放在 runApp 之前**

```dart
import 'package:news_check_app/database/database_helper.dart';
import 'package:news_check_app/utils/image_download_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;     // 初始化 sqflite
  await ImageDownloadService.instance.init();  // 启动图片下载队列
  runApp(const MyApp());
}
```

- [ ] **Step 2: 验证编译**

```bash
cd news_check_app && flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1 | grep -E "error"
```

Expected: 0 errors

- [ ] **Step 3: Commit**

```bash
git add news_check_app/lib/main.dart
git commit -m "feat: initialize DatabaseHelper and ImageDownloadService at app startup"
```