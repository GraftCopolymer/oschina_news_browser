import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/news_list_controller.dart';
import 'package:news_check_app/pages/news_detail_page.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';
import 'package:news_check_app/theme/app_colors.dart';
import 'package:news_check_app/widgets/staggered_news_card.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with AutomaticKeepAliveClientMixin {
  final _newsListController = Get.put(NewsListController());

  @override
  void initState() {
    super.initState();
    _newsListController.loadMore().onError((e, _) {
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
          _newsListController.loadMore();
          return true;
        }
        return false;
      },
      child: Obx(() {
        if (_newsListController.newsList.isEmpty) {
          return const ShimmerGrid();
        }
        return RefreshIndicator(
          onRefresh: () async {
            await _newsListController.refreshList();
          },
          displacement: 80,
          color: AppColors.primary,
          backgroundColor: Theme.of(context).cardColor,
          strokeWidth: 3,
          child: MasonryGridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: _newsListController.newsList.length,
            gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final news = _newsListController.newsList[index];
              // 根据标题长度决定高度
              final height = news.title.length <= 25
                  ? 200.0
                  : news.title.length <= 40
                      ? 250.0
                      : 280.0;
              return StaggeredNewsCard(
                news: news,
                height: height,
                onTap: (n) {
                  Get.to(() => NewsDetailPage(newsId: n.id));
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