# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authLogoutPost**](DefaultApi.md#authlogoutpost) | **POST** /auth/logout | 退出登录
[**authOschinaAuthorizeUrlGet**](DefaultApi.md#authoschinaauthorizeurlget) | **GET** /auth/oschina/authorize-url | 获取OSCHINA授权链接
[**authOschinaCallbackGet**](DefaultApi.md#authoschinacallbackget) | **GET** /auth/oschina/callback | OSCHINA授权回调接口
[**blogDetailIdGet**](DefaultApi.md#blogdetailidget) | **GET** /blog/detail/{id} | 获取博客详情
[**blogListGet**](DefaultApi.md#bloglistget) | **GET** /blog/list | 获取博客列表
[**collectAddPost**](DefaultApi.md#collectaddpost) | **POST** /collect/add | 添加收藏（新闻/博客）
[**collectListGet**](DefaultApi.md#collectlistget) | **GET** /collect/list | 获取我的收藏列表
[**collectRemovePost**](DefaultApi.md#collectremovepost) | **POST** /collect/remove | 取消收藏
[**newsDetailIdGet**](DefaultApi.md#newsdetailidget) | **GET** /news/detail/{id} | 获取新闻详情
[**newsListGet**](DefaultApi.md#newslistget) | **GET** /news/list | 获取新闻列表
[**searchGet**](DefaultApi.md#searchget) | **GET** /search | 全局搜索


# **authLogoutPost**
> ApiResponse authLogoutPost()

退出登录

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    final response = api.authLogoutPost();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authLogoutPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authOschinaAuthorizeUrlGet**
> ApiResponse authOschinaAuthorizeUrlGet()

获取OSCHINA授权链接

客户端调用此接口获取授权URL，通过WebView打开进行登录授权

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    final response = api.authOschinaAuthorizeUrlGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authOschinaAuthorizeUrlGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authOschinaCallbackGet**
> ApiResponse authOschinaCallbackGet(code)

OSCHINA授权回调接口

授权成功后回调，后端自动换取OSCHINA Token并生成客户端JWT

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String code = code_example; // String | OSCHINA授权码

try {
    final response = api.authOschinaCallbackGet(code);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authOschinaCallbackGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**| OSCHINA授权码 | 

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **blogDetailIdGet**
> ApiResponse blogDetailIdGet(id)

获取博客详情

后端代理OSCHINA接口，返回自定义详情数据

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int id = 56; // int | 博客ID

try {
    final response = api.blogDetailIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->blogDetailIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 博客ID | 

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **blogListGet**
> ApiResponse blogListGet(page, pageSize)

获取博客列表

后端代理OSCHINA接口，返回自定义适配列表

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.blogListGet(page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->blogListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collectAddPost**
> ApiResponse collectAddPost(collectRequest)

添加收藏（新闻/博客）

保存收藏类型+ID，后端关联用户

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final CollectRequest collectRequest = ; // CollectRequest | 

try {
    final response = api.collectAddPost(collectRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->collectAddPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **collectRequest** | [**CollectRequest**](CollectRequest.md)|  | 

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collectListGet**
> ApiResponse collectListGet(page, pageSize)

获取我的收藏列表

后端根据收藏ID批量请求OSCHINA，返回列表数据

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.collectListGet(page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->collectListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collectRemovePost**
> ApiResponse collectRemovePost(collectRequest)

取消收藏

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final CollectRequest collectRequest = ; // CollectRequest | 

try {
    final response = api.collectRemovePost(collectRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->collectRemovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **collectRequest** | [**CollectRequest**](CollectRequest.md)|  | 

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **newsDetailIdGet**
> ApiResponse newsDetailIdGet(id)

获取新闻详情

后端代理OSCHINA接口，返回自定义详情数据

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int id = 56; // int | 新闻ID

try {
    final response = api.newsDetailIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->newsDetailIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| 新闻ID | 

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **newsListGet**
> ApiResponse newsListGet(catalog, page, pageSize)

获取新闻列表

后端代理OSCHINA接口，返回自定义适配列表

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int catalog = 56; // int | 1=所有 2=综合新闻 3=软件更新
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.newsListGet(catalog, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->newsListGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **catalog** | **int**| 1=所有 2=综合新闻 3=软件更新 | [optional] [default to 1]
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchGet**
> ApiResponse searchGet(q, catalog, page, pageSize)

全局搜索

支持搜索新闻、博客，后端代理OSCHINA搜索接口

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final String q = q_example; // String | 搜索关键词
final String catalog = catalog_example; // String | 搜索类型
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.searchGet(q, catalog, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->searchGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| 搜索关键词 | 
 **catalog** | **String**| 搜索类型 | [optional] [default to 'news']
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**ApiResponse**](ApiResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

