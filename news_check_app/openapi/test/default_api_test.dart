import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for DefaultApi
void main() {
  final instance = Openapi().getDefaultApi();

  group(DefaultApi, () {
    // 退出登录
    //
    //Future<ApiResponse> authLogoutPost() async
    test('test authLogoutPost', () async {
      // TODO
    });

    // 获取OSCHINA授权链接
    //
    // 客户端调用此接口获取授权URL，通过WebView打开进行登录授权
    //
    //Future<ApiResponse> authOschinaAuthorizeUrlGet() async
    test('test authOschinaAuthorizeUrlGet', () async {
      // TODO
    });

    // OSCHINA授权回调接口
    //
    // 授权成功后回调，后端自动换取OSCHINA Token并生成客户端JWT
    //
    //Future<ApiResponse> authOschinaCallbackGet(String code) async
    test('test authOschinaCallbackGet', () async {
      // TODO
    });

    // 获取博客详情
    //
    // 后端代理OSCHINA接口，返回自定义详情数据
    //
    //Future<ApiResponse> blogDetailIdGet(int id) async
    test('test blogDetailIdGet', () async {
      // TODO
    });

    // 获取博客列表
    //
    // 后端代理OSCHINA接口，返回自定义适配列表
    //
    //Future<ApiResponse> blogListGet({ int page, int pageSize }) async
    test('test blogListGet', () async {
      // TODO
    });

    // 添加收藏（新闻/博客）
    //
    // 保存收藏类型+ID，后端关联用户
    //
    //Future<ApiResponse> collectAddPost(CollectRequest collectRequest) async
    test('test collectAddPost', () async {
      // TODO
    });

    // 获取我的收藏列表
    //
    // 后端根据收藏ID批量请求OSCHINA，返回列表数据
    //
    //Future<ApiResponse> collectListGet({ int page, int pageSize }) async
    test('test collectListGet', () async {
      // TODO
    });

    // 取消收藏
    //
    //Future<ApiResponse> collectRemovePost(CollectRequest collectRequest) async
    test('test collectRemovePost', () async {
      // TODO
    });

    // 获取新闻详情
    //
    // 后端代理OSCHINA接口，返回自定义详情数据
    //
    //Future<ApiResponse> newsDetailIdGet(int id) async
    test('test newsDetailIdGet', () async {
      // TODO
    });

    // 获取新闻列表
    //
    // 后端代理OSCHINA接口，返回自定义适配列表
    //
    //Future<ApiResponse> newsListGet({ int catalog, int page, int pageSize }) async
    test('test newsListGet', () async {
      // TODO
    });

    // 全局搜索
    //
    // 支持搜索新闻、博客，后端代理OSCHINA搜索接口
    //
    //Future<ApiResponse> searchGet(String q, { String catalog, int page, int pageSize }) async
    test('test searchGet', () async {
      // TODO
    });

  });
}
