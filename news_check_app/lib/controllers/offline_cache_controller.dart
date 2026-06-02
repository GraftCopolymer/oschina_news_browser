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
    cachedKeys.assignAll(await CacheDao.getAllKeys());
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