import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for ApiResponse
void main() {
  final instance = ApiResponseBuilder();
  // TODO add properties to the builder and call build()

  group(ApiResponse, () {
    // 响应码 200=成功 400=参数错误 401=未授权 500=服务器错误
    // int code
    test('to test the property `code`', () async {
      // TODO
    });

    // 响应信息
    // String msg
    test('to test the property `msg`', () async {
      // TODO
    });

    // 响应数据
    // JsonObject data
    test('to test the property `data`', () async {
      // TODO
    });

  });
}
