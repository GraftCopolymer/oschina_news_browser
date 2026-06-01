import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/mixins/detail_image_preview_mixin.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/pages/common_detail_markdown.dart';
import 'package:news_check_app/pages/common_detail_webview.dart';
import 'package:news_check_app/utils/passage_utils.dart';

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
    final token = Get.find<AuthController>().token.value;
    try {
      // 调用博客详情 API
      final resp = await api.blogDetailIdGet(
        id: widget.blogId,
        headers: {'Authorization': 'Bearer $token'},
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
      return Center(child: CircularProgressIndicator());
    } else if (_detail == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("加载失败"),
            TextButton(
              onPressed: () {
                _initData();
              },
              child: Text("重试"),
            ),
          ],
        ),
      );
    } else {
      switch (PassageUtils.detectType(_detail!.body)) {
        case ContentType.html:
          {
            return CommonDetailWebView(
              htmlContent: PassageUtils.htmlWrap(
                title: _detail!.title,
                author: _detail!.author,
                pubDate: _detail!.pubDate,
                body: _detail!.body,
              ),
              webViewKey: _webViewKey,
              onImageClick: (data) {
                handleImageClick(context, _webViewKey, data);
              },
            );
          }
        case ContentType.markdown:
          {
            return CommonDetailMarkdown(
              content: PassageUtils.markdownWrap(
                title: _detail!.title,
                author: _detail!.author,
                pubDate: _detail!.pubDate,
                body: _detail!.body,
              ),
            );
          }
      }
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