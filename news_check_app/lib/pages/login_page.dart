import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/pages/oschina_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset("assets/oschina_logo.png"),
            ),
            Text("使用 OSCHINA 认证登录", style: TextStyle(color: Colors.grey)),
            ElevatedButton(
              onPressed: () {
                Get.to(() => OschinaLoginPage(
                  onLoginSuccess: (token) {
                    Get.back();
                    Get.back();
                  },
                ));
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: [Text("去认证"), Icon(Icons.arrow_forward)]),
            ),
          ],
        ),
      ),
    );
  }
}
