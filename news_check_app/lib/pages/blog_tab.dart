import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/blog_list_controller.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';
import 'package:news_check_app/widgets/staggered_blog_card.dart';

class BlogTab extends StatefulWidget {
  const BlogTab({super.key});

  @override
  State<BlogTab> createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> with AutomaticKeepAliveClientMixin {
  final _blogListController = Get.put(BlogListController());

  @override
  void initState() {
    super.initState();
    _blogListController.loadMore().onError((e, _) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          Fluttertoast.showToast(msg: "登录过期, 请重新登录");
        } else {
          Fluttertoast.showToast(msg: "未知错误");
        }
      } else {
        Fluttertoast.showToast(msg: "未知错误");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.maxScrollExtent ==
            scrollNotification.metrics.pixels) {
          _blogListController.loadMore();
          return true;
        }
        return false;
      },
      child: Obx(() {
        if (_blogListController.blogList.isEmpty) {
          return const ShimmerGrid();
        }
        return RefreshIndicator(
          onRefresh: () async {
            _blogListController.refreshList();
          },
          child: MasonryGridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: _blogListController.blogList.length,
            gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final blog = _blogListController.blogList[index];
              final height = blog.title.length <= 25
                  ? 200.0
                  : blog.title.length <= 40
                      ? 250.0
                      : 280.0;
              return StaggeredBlogCard(
                blog: blog,
                height: height,
                onTap: (b) {
                  Get.to(() => BlogDetailPage(blogId: b.id));
                },
              );
            },
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}