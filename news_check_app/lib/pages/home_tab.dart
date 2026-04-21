import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/news_list_controller.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/utils/store_keys.dart';
import 'package:news_check_app/utils/store_utils.dart';
import 'package:news_check_app/utils/token_utils.dart';
import 'package:news_check_app/widgets/news_simple_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  final _newsListController = Get.put(NewsListController());

  Future<void> _test() async {
    final token = await StoreUtils.secure.read(key: StoreKeys.TOKEN); 
    debugPrint("用户 Token: $token");
    final model = TokenUtils.parseTokenModel(token!);
    debugPrint("$model");
  }

  @override
  void initState() {
    super.initState();
    _newsListController.loadMore().onError((e, _) {
      if (e is DioException) {
        if (e.response?.statusCode == 401)  {
          Fluttertoast.showToast(msg: "登录过期, 请重新登录");
        } else {
          Fluttertoast.showToast(msg: "未知错误");
        }
      } else {
        Fluttertoast.showToast(msg: "未知错误");
      }
    });
    _test();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("IT 新闻"),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.maxScrollExtent == scrollNotification.metrics.pixels) {
            _newsListController.loadMore();
            return true;
          }
          return false;
        },
        child: Obx(() {
          return ListView.builder(
            itemCount: _newsListController.newsList.length,
            itemBuilder: (context, index) {
              final newsSimple = _newsListController.newsList[index];
              return NewsSimpleCard(news: newsSimple, onTap: (news) {
                  // 跳转到新闻详情页
                  Get.to(() => NewsDetailPage(newsId: newsSimple.id,));
              },);
          });
        })
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}