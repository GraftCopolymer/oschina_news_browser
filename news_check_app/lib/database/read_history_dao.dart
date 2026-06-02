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
      final dateStr = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
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