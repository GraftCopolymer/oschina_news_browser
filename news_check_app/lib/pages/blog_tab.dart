import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
// 替换为你之前写的 BlogListController
import 'package:news_check_app/controllers/blog_list_controller.dart'; 
// 替换为对应的详情页和 Widget
import 'package:news_check_app/pages/blog_detail_page.dart'; 
import 'package:news_check_app/widgets/blog_simple_card.dart'; 
import 'package:news_check_app/utils/store_keys.dart';
import 'package:news_check_app/utils/store_utils.dart';
import 'package:news_check_app/utils/token_utils.dart';

class BlogTab extends StatefulWidget {
  const BlogTab({super.key});

  @override
  State<BlogTab> createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> with AutomaticKeepAliveClientMixin {
  // 使用 BlogListController
  final _blogListController = Get.put(BlogListController());

  Future<void> _test() async {
    final token = await StoreUtils.secure.read(key: StoreKeys.TOKEN); 
    debugPrint("用户 Token: $token");
    if (token != null) {
      final model = TokenUtils.parseTokenModel(token);
      debugPrint("$model");
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始加载博客列表
    _blogListController.loadMore().onError((e, _) {
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
    // 必须调用 super.build
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("最新博客"),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          // 滑动到底部触发加载更多
          if (scrollNotification.metrics.maxScrollExtent == scrollNotification.metrics.pixels) {
            _blogListController.loadMore();
            return true;
          }
          return false;
        },
        child: Obx(() {
          return RefreshIndicator(
            onRefresh: () async {
              _blogListController.refreshList();
            },
            child: ListView.builder(
              itemCount: _blogListController.blogList.length,
              itemBuilder: (context, index) {
                final blogSimple = _blogListController.blogList[index];
                // 使用对应的 BlogSimpleCard
                return BlogSimpleCard(
                  blog: blogSimple, 
                  onTap: (blog) {
                    // 跳转到博客详情页
                    Get.to(() => BlogDetailPage(blogId: blogSimple.id));
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}