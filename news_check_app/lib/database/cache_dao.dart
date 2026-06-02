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
  static Future<Database> _getDb() => DatabaseHelper.instance.database;

  /// 缓存文章（UPSERT 语义）
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
    await db.delete('image_cache', where: 'cache_key = ?', whereArgs: [cacheKey]);
    await db.delete('cache_items', where: 'item_type = ? AND item_id = ?', whereArgs: [type, id]);
  }

  /// 清空所有缓存（含图片表 + 本地图片文件）
  static Future<void> clearAll() async {
    final db = await _getDb();
    final images = await db.query(
      'image_cache',
      columns: ['local_path'],
      where: 'status = ?',
      whereArgs: ['completed'],
    );
    for (final img in images) {
      final path = img['local_path'] as String?;
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await db.delete('image_cache');
    await db.delete('cache_items');
  }

  /// 统计缓存数据大小（数据库 + 图片文件）
  static Future<int> getTotalSize() async {
    final db = await _getDb();
    final dbPath = DatabaseHelper.instance.dbFilePath;
    final dbFile = dbPath != null ? File(dbPath) : null;
    int total = 0;
    if (dbFile != null && await dbFile.exists()) {
      total += await dbFile.length();
    }
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

    final item = await db.query(
      'cache_items',
      columns: ['body', 'local_body'],
      where: 'item_type = ? AND item_id = ?',
      whereArgs: [type, id],
    );
    if (item.isEmpty) return;

    String body = item.first['local_body'] as String? ?? item.first['body'] as String;

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