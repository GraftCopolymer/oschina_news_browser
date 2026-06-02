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
                _buildStatCard(
                  icon: Icons.today,
                  title: "今日阅读",
                  subtitle: "${_controller.todayCount.value} 篇 · ${_formatWords(_controller.todayWords.value)} 字",
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  icon: Icons.auto_stories,
                  title: "累计阅读",
                  subtitle: "${_controller.totalCount.value} 篇 · ${_formatWords(_controller.totalWords.value)} 字",
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 24),
                Text("近 7 天阅读趋势", style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildLineChart(),
                ),
                const SizedBox(height: 24),
                Text("内容类型分布", style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildPieChart(),
                ),
                const SizedBox(height: 16),
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
                final dateLabel = _controller.dailyTrend[i].date;
                final dt = DateTime.tryParse(dateLabel);
                final display = dt != null
                    ? '${dt.month}/${dt.day}'
                    : dateLabel;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    display,
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
            isCurved: false,
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