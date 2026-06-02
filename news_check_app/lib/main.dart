import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/app_settings_controller.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/controllers/offline_cache_controller.dart';
import 'package:news_check_app/controllers/reading_stats_controller.dart';
import 'package:news_check_app/database/database_helper.dart';
import 'package:news_check_app/network/token_interceptor.dart';
import 'package:news_check_app/pages/account_page.dart';
import 'package:news_check_app/pages/login_page.dart';
import 'package:news_check_app/pages/home_page.dart';
import 'package:news_check_app/pages/search_page.dart';
import 'package:news_check_app/services/api_client.dart';
import 'package:news_check_app/utils/image_download_service.dart';
import 'package:news_check_app/utils/store_utils.dart';
import 'package:news_check_app/theme/app_theme.dart';
import 'package:news_check_app/widgets/bottom_navigation_bar.dart';

// 使用本地服务器进行测试
late final ApiClient api;

void _initApi() {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000"));

  dio.interceptors.add(TokenInterceptor());
  api = ApiClient(dio);
}

Future<void> main() async {
  _initApi();
  WidgetsFlutterBinding.ensureInitialized();
  await StoreUtils.init();
  await DatabaseHelper.instance.database;
  await ImageDownloadService.instance.init();
  final authController = Get.put(AuthController());
  final appSettingsController = Get.put(AppSettingsController());
  Get.put(OfflineCacheController());
  Get.put(ReadingStatsController());
  // 等待加载用户信息
  await authController.loadingFuture;
  await appSettingsController.loadingFuture;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: "开发者资讯",
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: Get.find<AppSettingsController>().themeMode.value
            .toFlutterThemeMode(),
        home: Obx(() {
          return Get.find<AuthController>().isLoggedIn.value
              ? AppFrame()
              : LoginPage();
        }),
      );
    });
  }
}

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame>
    with SingleTickerProviderStateMixin {
  // 新闻浏览页和个人中心页面
  final List<Widget> _pages = [NewsPage(), SearchPage(), AccountPage()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: MyNavigationBar(
        onPageChanged: (oldIndex, newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        tabs: [
          MyNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28),
            activeIcon: Icon(Icons.home, size: 28),
            label: "首页",
          ),
          MyNavigationBarItem(
            icon: Icon(Icons.search_outlined, size: 28),
            activeIcon: Icon(Icons.search, size: 28),
            label: "搜索",
          ),
          MyNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, size: 28),
            activeIcon: Icon(Icons.account_circle_rounded, size: 28),
            label: "我的",
          ),
        ],
      ),
    );
  }
}