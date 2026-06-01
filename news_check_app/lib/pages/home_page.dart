import 'package:flutter/material.dart';
import 'package:news_check_app/pages/blog_tab.dart';
import 'package:news_check_app/pages/news_tab.dart';
import 'package:news_check_app/widgets/home_header.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _tabPages = const [NewsTab(), BlogTab()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          const HomeHeader(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(60),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: colorScheme.onSurface.withAlpha(150),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              tabs: const [
                Tab(text: "新闻"),
                Tab(text: "博客"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(controller: _tabController, children: _tabPages),
          ),
        ],
      ),
    );
  }
}