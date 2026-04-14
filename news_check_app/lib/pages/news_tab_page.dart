import 'package:flutter/material.dart';
import 'package:news_check_app/pages/home_tab.dart';
import 'package:news_check_app/pages/oschina_login_page.dart';

class NewsTabPage extends StatefulWidget {
  const NewsTabPage({super.key});

  @override
  State<NewsTabPage> createState() => _NewsTabPageState();
}

class _NewsTabPageState extends State<NewsTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Tab 页面
  final _tabPages = [HomeTab(), OschinaLoginPage(), HomeTab()];

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
            Tab(text: "首页", icon: Icon(Icons.newspaper)),
            Tab(text: "最热", icon: Icon(Icons.fire_extinguisher)),
            Tab(text: "最新", icon: Icon(Icons.nat)),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: _tabPages),
    );
  }
}
