import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/pages/account_page.dart';
import 'package:news_check_app/pages/login_page.dart';
import 'package:news_check_app/pages/news_tab_page.dart';
import 'package:news_check_app/utils/store_utils.dart';
import 'package:news_check_app/widgets/bottom_navigation_bar.dart';
import 'package:openapi/openapi.dart';

// 使用本地服务器进行测试
final api = Openapi(basePathOverride: "http://10.0.2.2:8000").getDefaultApi();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoreUtils.init();
  final authController = Get.put(AuthController());
  // 等待加载用户信息
  await authController.loadingFuture;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "开发者资讯",
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Obx(() {
        return Get.find<AuthController>().isLoggedIn.value ? AppFrame() : LoginPage();
      }),
    );
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
  final List<Widget> _pages = [
    NewsTabPage(),
    AccountPage(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: MyNavigationBar(
        onPageChanged: (oldIndex, newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        tabs: [
          MyNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 40,),
            activeIcon: Icon(Icons.home, size: 40),
          ),
          MyNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, size: 40),
            activeIcon: Icon(Icons.account_circle_rounded, size: 40),
          ),
        ],
      ),
    );
  }
}
