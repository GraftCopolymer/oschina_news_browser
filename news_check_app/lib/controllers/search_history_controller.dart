import 'package:get/get.dart';
import 'package:news_check_app/mixins/future_load_mixin.dart';
import 'package:news_check_app/utils/store_keys.dart';
import 'package:news_check_app/utils/store_utils.dart';

class SearchHistoryController extends GetxController with FutureLoadMixin {
  final RxList<String> history = (<String>[]).obs;

  Future<void> _loadHistory() async {
    history.clear();
    history.addAll(StoreUtils.pref.getStringList(StoreKeys.SEARCH_HISTORY) ?? []);
    history.refresh();
  }

  Future<void> removeHistory(String content) async {
    history.remove(content);
    history.refresh();
    await StoreUtils.pref.setStringList(StoreKeys.SEARCH_HISTORY, history.toList());
  }

  Future<void> clearHistory() async {
    history.clear();
    history.refresh();
    await StoreUtils.pref.setStringList(StoreKeys.SEARCH_HISTORY, []);
  }

  Future<void> addHistory(String content) async {
    // 如果已存在则删除旧记录（保证不重复）
    history.remove(content);
    // 插入到最前面
    history.insert(0, content);
    history.refresh();
    // 持久化到本地存储
    await StoreUtils.pref.setStringList(StoreKeys.SEARCH_HISTORY, history.toList());
  }

  @override
  void onInit() {
    super.onInit();
    startLoad();
    _loadHistory().then((_) {
      endLoad();
    });
  }
}