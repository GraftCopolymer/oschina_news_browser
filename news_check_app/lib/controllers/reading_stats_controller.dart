import 'package:get/get.dart';
import 'package:news_check_app/database/read_history_dao.dart';

class ReadingStatsController extends GetxController {
  final todayCount = 0.obs;
  final totalCount = 0.obs;
  final todayWords = 0.obs;
  final totalWords = 0.obs;
  final dailyTrend = <DailyStat>[].obs;
  final typeDist = <TypeStat>[].obs;

  @override
  Future<void> refresh() async {
    todayCount.value = await ReadHistoryDao.getTodayCount();
    totalCount.value = await ReadHistoryDao.getTotalCount();
    todayWords.value = await ReadHistoryDao.getTodayWordCount();
    totalWords.value = await ReadHistoryDao.getTotalWordCount();
    dailyTrend.value = await ReadHistoryDao.getDailyTrend(7);
    typeDist.value = await ReadHistoryDao.getTypeDistribution();
  }
}