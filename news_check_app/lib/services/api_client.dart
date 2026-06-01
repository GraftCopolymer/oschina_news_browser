import 'package:dio/dio.dart';

/// 自定义 API 客户端，替代 OpenAPI 生成的 DefaultApi。
/// 直接使用 Dio，返回原始 JSON Map，不再经过 built_value 序列化。
class ApiClient {
  final Dio _dio;

  const ApiClient(this._dio);

  // ── 认证授权 ──────────────────────────────────────

  /// 获取 OSCHINA 授权链接
  Future<Response<dynamic>> authOschinaAuthorizeUrlGet({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/auth/oschina/authorize-url',
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  /// OSCHINA 授权回调，用 code 换取后端 JWT
  Future<Response<dynamic>> authOschinaCallbackGet({
    required String code,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/auth/oschina/callback',
      queryParameters: {'code': code},
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  /// 退出登录
  Future<Response<dynamic>> authLogoutPost({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post(
      '/auth/logout',
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  // ── 新闻管理 ──────────────────────────────────────

  /// 获取新闻列表
  Future<Response<dynamic>> newsListGet({
    int? catalog = 1,
    String? page = '1',
    String? pageSize = '20',
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/news/list',
      queryParameters: {
        if (catalog != null) 'catalog': catalog,
        if (page != null) 'page': page,
        if (pageSize != null) 'pageSize': pageSize,
      },
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  /// 获取新闻详情
  Future<Response<dynamic>> newsDetailIdGet({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/news/detail/$id',
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  // ── 博客管理 ──────────────────────────────────────

  /// 获取博客列表
  Future<Response<dynamic>> blogListGet({
    String? page = '1',
    String? pageSize = '20',
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/blog/list',
      queryParameters: {
        if (page != null) 'page': page,
        if (pageSize != null) 'pageSize': pageSize,
      },
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  /// 获取博客详情
  Future<Response<dynamic>> blogDetailIdGet({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/blog/detail/$id',
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  // ── 搜索 ──────────────────────────────────────────

  /// 全局搜索
  Future<Response<dynamic>> searchGet({
    required String q,
    String? catalog = 'news',
    int? page = 1,
    int? pageSize = 20,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/search',
      queryParameters: {
        'q': q,
        if (catalog != null) 'catalog': catalog,
        if (page != null) 'page': page,
        if (pageSize != null) 'pageSize': pageSize,
      },
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  // ── 收藏管理 ──────────────────────────────────────

  /// 添加收藏
  Future<Response<dynamic>> collectAddPost({
    required Map<String, dynamic> collectRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post(
      '/collect/add',
      data: collectRequest,
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  /// 取消收藏
  Future<Response<dynamic>> collectRemovePost({
    required Map<String, dynamic> collectRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post(
      '/collect/remove',
      data: collectRequest,
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }

  /// 获取收藏列表
  Future<Response<dynamic>> collectListGet({
    int? page = 1,
    int? pageSize = 20,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return _dio.get(
      '/collect/list',
      queryParameters: {
        if (page != null) 'page': page,
        if (pageSize != null) 'pageSize': pageSize,
      },
      options: Options(
        headers: headers,
      ),
      cancelToken: cancelToken,
    );
  }
}