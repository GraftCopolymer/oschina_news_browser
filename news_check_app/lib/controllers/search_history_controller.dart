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
    // 先检查有无相同的搜索记录
    bool alreadyHas = false;
    int index = 0;
    for (; index < history.length; index++) {
      if (history[index] == content) {
        alreadyHas = true;
        break;
      }
    }
    if (alreadyHas) {
      history.removeAt(index);
    }
    history.insert(0, content);
    history.refresh();
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