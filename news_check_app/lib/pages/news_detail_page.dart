import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/mixins/detail_image_preview_mixin.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/pages/common_detail_webview.dart';
import 'package:news_check_app/database/cache_dao.dart';
import 'package:news_check_app/database/read_history_dao.dart';
import 'package:news_check_app/utils/image_download_service.dart';
import 'package:news_check_app/utils/passage_utils.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key, required this.newsId});

  final int newsId;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>
    with DetailImagePreviewMixin {
  NewsDetail? _detail;
  bool _loading = true;

  final _webViewKey = GlobalKey();

  Future<void> _initData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      final resp = await api.newsDetailIdGet(
        id: widget.newsId,
      );
      final body = resp.data as Map<String, dynamic>?;
      if (resp.statusCode != 200 || body == null) {
        Fluttertoast.showToast(msg: "获取新闻信息失败 ${resp.statusCode}");
        return;
      }
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        Fluttertoast.showToast(msg: "错误 数据未正常发送");
        return;
      }
      final newsDetail = NewsDetail.fromJson(data['news_detail']);
                      // 自动缓存
                      final wordCount = PassageUtils.countReadableChars(newsDetail.body);
                      await CacheDao.insert(
                        type: 'news',
                        id: newsDetail.id,
                        title: newsDetail.title,
                        author: newsDetail.author,
                        pubDate: newsDetail.pubDate,
                        body: newsDetail.body,
                      );
                      await ReadHistoryDao.recordRead(
                        type: 'news',
                        id: newsDetail.id,
                        title: newsDetail.title,
                        wordCount: wordCount,
                      );
                      // 触发图片下载
                      final imageUrls = PassageUtils.extractImageUrls(newsDetail.body);
                      if (imageUrls.isNotEmpty) {
                        ImageDownloadService.instance
                            .enqueueImageDownloads('news_${newsDetail.id}', imageUrls);
                      }
                      // 构造自适应屏幕的 HTML 内容
      if (mounted) {
        setState(() {
          _detail = newsDetail;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "发生错误");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: ShimmerCard());
    } else if (_detail == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text("加载失败"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 40),
              ),
              child: const Text("重试"),
            ),
          ],
        ),
      );
    } else {
      return CommonDetailWebView(
        htmlContent: PassageUtils.wrapBodyForWebView(
          title: _detail!.title,
          author: _detail!.author,
          pubDate: _detail!.pubDate,
          body: _detail!.body,
          isDark: Get.isDarkMode,
        ),
        webViewKey: _webViewKey,
        onImageClick: (data) {
          handleImageClick(context, _webViewKey, data);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("详情")),
      body: _buildBody(),
    );
  }
}