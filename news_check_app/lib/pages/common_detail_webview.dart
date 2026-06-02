import 'dart:async';
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
    required this.tocEntries,
    this.scrollToTocNotifier,
  });

  final String htmlContent;
  final GlobalKey webViewKey;
  final Function(Map<String, dynamic> data)? onImageClick;
  final Function(int progress)? onProgressChanged;
  final Function(int scrollTop)? onScrollChanged;
  final List<TocEntry> tocEntries;
  final ValueNotifier<String?>? scrollToTocNotifier;

  @override
  State<CommonDetailWebView> createState() => _CommonDetailWebViewState();
}

class _CommonDetailWebViewState extends State<CommonDetailWebView> {
  late final WebViewController _controller;
  final _settingsCtrl = Get.find<ReadingSettingsController>();
  late final Worker _fontSizeWorker, _lineSpacingWorker, _readingBgWorker;
  Timer? _scrollPollTimer;
  bool _pollingInProgress = false;

  void injectSettings() {
    _controller.runJavaScript(_settingsCtrl.injectCssVariablesJs);
  }

  String get _injectAllJs => '''
    (function() {
      ${_settingsCtrl.injectCssVariablesJs.replaceAll('(function() {', '').replaceAll('})();', '')}
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
    })();
  ''';

  /// 轮询 WebView 滚动位置（用分隔符替代 JSON.stringify，避免编码问题）
  String get _pollJs => '''
    (function() {
      var st = document.documentElement.scrollTop || document.body.scrollTop;
      var ch = document.documentElement.clientHeight;
      var sh = document.documentElement.scrollHeight;
      var diff = sh - ch;
      var p = diff > 0 ? Math.round(st / diff * 100) : 0;
      return Math.round(st) + '|' + Math.round(p) + '|' + Math.round(ch) + '|' + Math.round(sh);
    })();
  ''';

  void _startScrollPolling() {
    _scrollPollTimer?.cancel();
    debugPrint('[poll] starting scroll polling...');
    _scrollPollTimer = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      if (_pollingInProgress) return;
      _pollingInProgress = true;
      try {
        final raw = await _controller.runJavaScriptReturningResult(_pollJs);
        // 去除平台通道附加的双引号
        final result = (raw is String) ? raw.replaceAll('"', '') : '';
        final parts = result.split('|');
        if (parts.length >= 2) {
          final scrollTop = int.tryParse(parts[0]) ?? 0;
          final progress = int.tryParse(parts[1]) ?? 0;
          debugPrint('[poll] scrollTop=$scrollTop progress=$progress (ch=${parts.length>2 ? parts[2] : '?'} sh=${parts.length>3 ? parts[3] : '?'})');
          widget.onProgressChanged?.call(progress);
          widget.onScrollChanged?.call(scrollTop);
        } else {
          debugPrint('[poll] unexpected format: "$raw"');
        }
      } catch (e) {
        debugPrint('[poll] ERROR: $e');
      } finally {
        _pollingInProgress = false;
      }
    });
  }

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
            _startScrollPolling();
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
    _scrollPollTimer?.cancel();
    _fontSizeWorker();
    _lineSpacingWorker();
    _readingBgWorker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(key: widget.webViewKey, controller: _controller);
}