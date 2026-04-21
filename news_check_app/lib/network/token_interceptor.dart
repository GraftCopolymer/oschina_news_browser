import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:news_check_app/pages/login_page.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // 跳转到登录页面
      Get.to(() => LoginPage());
    }
    super.onError(err, handler);
  }
}