import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key, required this.newsId});

  final int newsId;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  NewsDetail? _detail;
  bool _loading = true;
  /// 当前是否是第一次加载页面
  bool _isInitView = false;

  late final WebViewController _webController;

  String _processHtml(NewsDetail newsDetail) {
    return """
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 0 auto;
          }
          body {
            word-wrap: break-word;
            padding: 8px; /* 增加一点内边距 */
          }
          .author {
            color: grey;
          }
          .pubDate {
            color: grey;
          }
          .news_meta_div {
            display: flex;
            align-items: center;
            justify-content: space-between;
          }
        </style>
      </head>
      <body>
        <h1> ${newsDetail.title} </h1>
        <div class="news_meta_div">
          <p class="author"> 作者: ${newsDetail.author} </p>
          <p class="pubDate"> ${newsDetail.pubDate} </p>
        </div>
        ${newsDetail.body}
      </body>
      </html>
      """;
  }

  Future<void> _initData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });
    final token = Get.find<AuthController>().token.value;
    try {
      final resp = await api.newsDetailIdGet(
        id: widget.newsId,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp.statusCode != 200) {
        Fluttertoast.showToast(msg: "获取新闻信息失败 ${resp.statusCode}");
        return;
      }
      final respData = resp.data;
      if (respData == null) {
        Fluttertoast.showToast(msg: "无数据");
        return;
      }
      final newsData = respData.data?.asMap;
      if (newsData == null) {
        Fluttertoast.showToast(msg: "错误 数据未正常发送");
        return;
      }
      final newsDetail = NewsDetail.fromJson(newsData['news_detail']);
      // 构造自适应屏幕的 HTML 内容
      String adaptiveHtml = _processHtml(newsDetail);
      await _webController.loadHtmlString(adaptiveHtml);
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
      return WebViewWidget(controller: _webController);
    }
  }

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          if (_isInitView) {
            _isInitView = false;
            return NavigationDecision.navigate;
          }
          // 后续在 WebView 内跳转都打开用户浏览器
          final Uri uri = Uri.parse(request.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            await Fluttertoast.cancel();
            await Fluttertoast.showToast(msg: "未检测到手机浏览器");
          }
          return NavigationDecision.prevent;
        },
      ));
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("详情")),
      body: _buildBody()
    );
  }
}
