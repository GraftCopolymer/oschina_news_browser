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
      var ticking = false;
      window.onscroll = function() {
        if (!ticking) {
          window.requestAnimationFrame(function() {
            var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
            var scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            if (scrollHeight > 0) {
              var progress = Math.round(scrollTop / scrollHeight * 100);
              ReadingProgress.postMessage(JSON.stringify({progress: progress, scrollTop: scrollTop}));
            }
            ticking = false;
          });
          ticking = true;
        }
      };
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
          final progress = data['progress'] as int;
          final scrollTop = data['scrollTop'] as int;
          widget.onProgressChanged?.call(progress);
          widget.onScrollChanged?.call(scrollTop);
        },
      )
      ..loadHtmlString(widget.htmlContent);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(key: widget.webViewKey, controller: _controller);
}