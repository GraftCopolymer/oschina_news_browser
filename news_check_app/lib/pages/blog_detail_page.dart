import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/mixins/detail_image_preview_mixin.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/pages/common_detail_webview.dart';
import 'package:news_check_app/utils/passage_utils.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';

class BlogDetailPage extends StatefulWidget {
  const BlogDetailPage({super.key, required this.blogId});

  final int blogId;

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage>
    with DetailImagePreviewMixin {
  BlogDetail? _detail;
  bool _loading = true;

  final _webViewKey = GlobalKey();

  Future<void> _initData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    try {
      // 调用博客详情 API
      final resp = await api.blogDetailIdGet(
        id: widget.blogId,
      );
      final body = resp.data as Map<String, dynamic>?;
      if (resp.statusCode != 200 || body == null) {
        Fluttertoast.showToast(msg: "获取博客信息失败 ${resp.statusCode}");
        return;
      }
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        Fluttertoast.showToast(msg: "错误 数据未正常发送");
        return;
      }

      // 解析为 BlogDetail
      final blogDetail = BlogDetail.fromJson(data['blog_detail']);

      if (mounted) {
        setState(() {
          _detail = blogDetail;
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
      appBar: AppBar(title: const Text("博客详情")),
      body: _buildBody(),
    );
  }
}