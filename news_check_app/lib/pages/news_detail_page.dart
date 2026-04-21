import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/widgets/hero_page_route.dart';
import 'package:photo_view/photo_view.dart';
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

  final _webViewKey = GlobalKey();

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
      return WebViewWidget(key: _webViewKey, controller: _webController);
    }
  }

  void _injectImageClickListener() {
    final js = """
      (function() {
        var imgs = document.getElementsByTagName('img');
        var ratio = window.devicePixelRatio || 1; 
        
        for (var i = 0; i < imgs.length; i++) {
          // 确保图片加载完成才能获取尺寸
          if(imgs[i].complete) {
             setupClick(imgs[i]);
          } else {
             imgs[i].onload = function() { setupClick(this); }
          }
        }

        function setupClick(img) {
          img.onclick = function(e) {
            // 获取图片相对于 viewport 的位置
            var rect = this.getBoundingClientRect();
            
            // 构建发送给 Flutter 的数据
            var imageData = {
              src: this.currentSrc || this.src,
              x: rect.left * ratio,
              y: rect.top * ratio,
              width: rect.width * ratio,
              height: rect.height * ratio
            };
            
            // 发送 JSON 字符串
            ImageHeroApp.postMessage(JSON.stringify(imageData));
          }
        }
      })();
    """;
    _webController.runJavaScript(js);
  }

  void _handleImageClick(BuildContext context, Map<String, dynamic> data) {
    final url = data['src'] as String;

    final RenderBox? webRenderBox =
        _webViewKey.currentContext?.findRenderObject() as RenderBox?;
    if (webRenderBox == null) return;
    final webViewOffset = webRenderBox.localToGlobal(Offset.zero);

    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final Rect imageRect = Rect.fromLTWH(
      (data['x'] / pixelRatio) + webViewOffset.dx,
      (data['y'] / pixelRatio) + webViewOffset.dy,
      data['width'] / pixelRatio,
      data['height'] / pixelRatio,
    );

    Navigator.of(context).push(
      HeroPhotoOverlayRoute(
        imageRect: imageRect,
        imageUrl: url,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
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
          onPageFinished: (url) {
            // 注入图片点击事件
            _injectImageClickListener();
          },
        ),
      )
      ..addJavaScriptChannel(
        "ImageHeroApp",
        onMessageReceived: (message) {
          if (mounted) {
            try {
              final Map<String, dynamic> data = jsonDecode(message.message);
              _handleImageClick(context, data);
            } catch (e) {
              debugPrint("解析图片数据失败: $e");
            }
          }
        },
      );
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
