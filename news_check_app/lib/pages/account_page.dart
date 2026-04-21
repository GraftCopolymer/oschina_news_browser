import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:news_check_app/controllers/auth_controller.dart';
import 'package:news_check_app/pages/login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _authController = Get.find<AuthController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的账户"),
      ),
      body: Obx(() {
        switch (_authController.isLoggedIn.value) {
          case false: {
            return Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("尚未登录"),
                TextButton(onPressed: (){
                  Get.to(() => LoginPage());
                }, child: Text("去登录", style: TextStyle(color: Colors.blue),))
              ],
            ),);
          }
          case true: {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipOval(child: Image.network(_authController.userInfo.value.avatar, width: 64, height: 64,fit: BoxFit.cover,)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_authController.userInfo.value.username, style: TextStyle(fontSize: 20),),
                            Text("用户")
                          ],
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: () async {
                    // 退出登录
                    await _authController.logout();
                  }, child: Text("退出登录"))
                ],
              ),
            );
          }
        }
      }),
    );
  }
}