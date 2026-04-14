import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 从后端获取 OSCHINA 的认证链接并访问, 用户授权后获取授权码, 上传后端
class OschinaLoginPage extends StatefulWidget {
  const OschinaLoginPage({super.key, this.onLoginSuccess});

  final Function(String token)? onLoginSuccess;

  @override
  State<OschinaLoginPage> createState() => _OschinaLoginPageState();
}

class _OschinaLoginPageState extends State<OschinaLoginPage> with AutomaticKeepAliveClientMixin {
  final _authController = Get.find<AuthController>();
  final _webViewController = WebViewController();

  bool _canGoBack = false;
  bool _canGoForward = false;

  Worker? _statusWorker;

  Widget _buildBottomWebNavBar() {
    return Container(
      height: 64,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: _canGoBack
                  ? () async {
                      if (await _webViewController.canGoBack()) {
                        await _webViewController.goBack();
                      }
                    }
                  : null,
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: _canGoForward
                  ? () async {
                      if (await _webViewController.canGoForward()) {
                        await _webViewController.goForward();
                      }
                    }
                  : null,
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理登录成功
  /// [userCode] 用户登录成功授权码
   Future<void> _processUserAuthSuccess(String userCode) async {
    debugPrint("用户授权成功, 授权码: $userCode");
    await _authController.loginApp(userCode);
    switch (_authController.loginAppStatus.value) {
      case LoginAppStatus.success: {
        Fluttertoast.showToast(msg: "登录成功");
        widget.onLoginSuccess?.call(_authController.token.value);
      }
      default: {
        Fluttertoast.showToast(msg: "登录失败");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化 WebViewController
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            debugPrint("请求URL: $url");
            // 检查 URL 是否包含 code 参数
            final uri = Uri.parse(url);
            if (uri.queryParameters.containsKey('code')) {
              final userCode = uri.queryParameters['code'];
              if (userCode != null && userCode.isNotEmpty) {
                _processUserAuthSuccess(userCode);
              } else {
                Fluttertoast.showToast(msg: "登录失败, 无法获取用户授权码");
                Get.back();
              }
            }
            _canGoBack = await _webViewController.canGoBack();
            _canGoForward = await _webViewController.canGoForward();
            if (mounted) {
              setState(() {});
            }
          },
          onNavigationRequest: (request) {
            // 阻止重定向, 后续逻辑交由 _processUserAuthSuccess 处理
            final urlString = request.url;
            if (urlString.startsWith("https://news.graftcopolymer.love")) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
      // 初始化认证 URL
    _authController.fetchAuthUrl();
    if (_authController.urlFetchStatus.value == UrlFetchStatus.success) {
      _webViewController.loadRequest(Uri.parse(_authController.authUrl.value));
    } else {
      // 监听变化
      _statusWorker = ever(_authController.urlFetchStatus, (status) {
        if (!mounted) return;
        if (status == UrlFetchStatus.success) {
          _webViewController.loadRequest(Uri.parse(_authController.authUrl.value));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text("OSCHINA 认证登录")),
      body: Obx(() {
        switch (_authController.urlFetchStatus.value) {
          case UrlFetchStatus.loading: {
            return Center(child: CircularProgressIndicator(),);
          }
          case UrlFetchStatus.failed: {
            return Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("获取认证链接失败 ${_authController.urlFetchErrorMsg}"),
                TextButton(onPressed: (){
                  _authController.fetchAuthUrl();
                }, child: Text("重试", style: TextStyle(color: Colors.red),))
              ],
            ),);
          }
          case UrlFetchStatus.success: {
            // 加载链接
            return WebViewWidget(controller: _webViewController);
          }
        }
      }),
      bottomNavigationBar: _buildBottomWebNavBar(),
    );
  }

  @override
  void dispose() {
    _statusWorker?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
