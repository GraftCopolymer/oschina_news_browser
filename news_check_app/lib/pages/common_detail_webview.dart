import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/reading_settings_controller.dart';
import 'package:news_check_app/utils/passage_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonDetailWebView extends StatefulWidget {
  const CommonDetailWebView({
    super.key,
    required this.htmlContent,
    required this.webViewKey,
    this.onImageClick,
    this.onProgressChanged,
    this.onScrollChanged,
    this.onTap,
    required this.tocEntries,
    this.scrollToTocNotifier,
  });

  final String htmlContent;
  final GlobalKey webViewKey;
  final Function(Map<String, dynamic> data)? onImageClick;
  final Function(int progress)? onProgressChanged;
  final Function(int scrollTop)? onScrollChanged;
  final VoidCallback? onTap;
  final List<TocEntry> tocEntries;
  final ValueNotifier<String?>? scrollToTocNotifier;

  @override
  State<CommonDetailWebView> createState() => _CommonDetailWebViewState();
}

class _CommonDetailWebViewState extends State<CommonDetailWebView> {
  late final WebViewController _controller;
  final _settingsCtrl = Get.find<ReadingSettingsController>();
  late final Worker _fontSizeWorker, _lineSpacingWorker, _readingBgWorker;

  void injectSettings() {
    _controller.runJavaScript(_settingsCtrl.injectCssVariablesJs);
  }

  /// 注入图片点击 + 滚动检测 + 点击切换 UI
  String get _injectAllJs => '''
    (function() {
      ${_settingsCtrl.injectCssVariablesJs.replaceAll('(function() {', '').replaceAll('})();', '')}
      // 图片点击放大
      var imgs = document.getElementsByTagName('img');
      var ratio = window.devicePixelRatio || 1;
      for (var i = 0; i < imgs.length; i++) {
        imgs[i].onclick = function() {
          var rect = this.getBoundingClientRect();
          ImageHeroApp.postMessage(JSON.stringify({
            src: this.src,
            x: rect.left * ratio, y: rect.top * ratio,
            width: rect.width * ratio, height: rect.height * ratio
          }));
        };
      }
      // 滚动检测
      window.addEventListener('scroll', function() {
        var scrollTop = window.scrollY;
        var scrollHeight = document.body.scrollHeight;
        var clientHeight = window.innerHeight;
        var diff = scrollHeight - clientHeight;
        var progress = diff > 0 ? Math.round(scrollTop / diff * 100) : 0;
        ReadingProgress.postMessage(JSON.stringify({progress: progress, scrollTop: scrollTop}));
      }, {passive: true});
      // 单击切换 UI（排除 A/IMG 避免冲突）
      document.addEventListener('click', function(e) {
        var tag = e.target.tagName;
        if (tag !== 'A' && tag !== 'IMG' && tag !== 'BUTTON') {
          WebViewTap.postMessage('tap');
        }
      });
    })();
  ''';

  @override
  void initState() {
    super.initState();
    widget.scrollToTocNotifier?.addListener(_onScrollToTocCommand);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final uri = Uri.parse(request.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              await Fluttertoast.showToast(msg: "未检测到手机浏览器");
            }
            return NavigationDecision.prevent;
          },
          onPageFinished: (_) {
            _controller.runJavaScript(_injectAllJs);
          },
        ),
      )
      ..addJavaScriptChannel(
        "ImageHeroApp",
        onMessageReceived: (msg) {
          final data = jsonDecode(msg.message);
          widget.onImageClick?.call(data);
        },
      )
      ..addJavaScriptChannel(
        "ReadingProgress",
        onMessageReceived: (msg) {
          final data = jsonDecode(msg.message) as Map<String, dynamic>;
          final progress = (data['progress'] as num?)?.toInt() ?? 0;
          final scrollTop = (data['scrollTop'] as num?)?.toInt() ?? 0;
          widget.onProgressChanged?.call(progress);
          widget.onScrollChanged?.call(scrollTop);
        },
      )
      ..addJavaScriptChannel(
        "WebViewTap",
        onMessageReceived: (_) {
          widget.onTap?.call();
        },
      )
      ..loadHtmlString(widget.htmlContent);

    // 监听阅读设置变化，实时注入 WebView
    _fontSizeWorker = ever(_settingsCtrl.fontSize, (_) => injectSettings());
    _lineSpacingWorker = ever(_settingsCtrl.lineSpacing, (_) => injectSettings());
    _readingBgWorker = ever(_settingsCtrl.readingBg, (_) => injectSettings());
  }

  void _onScrollToTocCommand() {
    final tocId = widget.scrollToTocNotifier?.value;
    if (tocId != null) {
      _controller.runJavaScript('''
        document.getElementById('$tocId').scrollIntoView({behavior: 'smooth', block: 'start'});
      ''');
    }
  }

  @override
  void dispose() {
    widget.scrollToTocNotifier?.removeListener(_onScrollToTocCommand);
    _fontSizeWorker();
    _lineSpacingWorker();
    _readingBgWorker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(key: widget.webViewKey, controller: _controller);
}