import 'package:flutter/material.dart';
import 'package:news_check_app/pages/blog_tab.dart';
import 'package:news_check_app/pages/news_tab.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Tab 页面
  final _tabPages = [NewsTab(), BlogTab(), NewsTab()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 取消 toolbarHeight
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3,
          tabs: [
            Tab(text: "新闻", icon: Icon(Icons.newspaper)),
            Tab(text: "博客", icon: Icon(Icons.fire_extinguisher)),
            Tab(text: "最新", icon: Icon(Icons.nat)),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: _tabPages),
    );
  }
}
