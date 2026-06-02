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
  int retryCount = 0;

  _DownloadTask({
    required this.id,
    required this.cacheKey,
    required this.url,
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
    final pending = await CacheDao.getPendingImageTasks(limit: 100);
    for (final task in pending) {
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
      await CacheDao.updateImageStatus(task.id, 'downloading');

      final imageDir = await _getImageDir();
      final ext = _guessExtension(task.url);
      final fileName = '${_hashUrl(task.url)}$ext';
      final filePath = '$imageDir/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        await CacheDao.updateImageStatus(task.id, 'completed', localPath: filePath);
        await CacheDao.updateLocalBody(task.cacheKey);
        return;
      }

      await _dio.download(task.url, filePath);

      if (await file.exists() && await file.length() > 0) {
        await CacheDao.updateImageStatus(task.id, 'completed', localPath: filePath);
      } else {
        if (await file.exists()) await file.delete();
        throw Exception('Downloaded file is empty');
      }

      await CacheDao.updateLocalBody(task.cacheKey);
    } catch (e) {
      if (task.retryCount < _maxRetries) {
        task.retryCount++;
        await CacheDao.updateImageStatus(task.id, 'pending');
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
    return '.jpg';
  }
}