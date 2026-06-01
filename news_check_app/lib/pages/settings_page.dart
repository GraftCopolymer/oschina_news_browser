import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:news_check_app/controllers/app_settings_controller.dart';
import 'package:news_check_app/widgets/setting_item_group.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _appSettingsController = Get.find<AppSettingsController>();

  String _themeModeName(MyThemeMode themeMode) {
    switch (themeMode) {
      case MyThemeMode.sys:
        return "跟随系统";
      case MyThemeMode.light:
        return "浅色模式";
      case MyThemeMode.dark:
        return "深色模式";
    }
  }

  Future<void> _showThemeChangeDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        MyThemeMode themeMode = _appSettingsController.themeMode.value;
        return AlertDialog(
          title: Text("主题模式"),
          content: StatefulBuilder(builder: (context, setState) {
            return RadioGroup<MyThemeMode>(
              groupValue: themeMode,
              onChanged: (mode) {
                setState(() => themeMode = mode!,);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(value: MyThemeMode.sys, title: Text("跟随系统")),
                  RadioListTile(value: MyThemeMode.light, title: Text("浅色模式")),
                  RadioListTile(value: MyThemeMode.dark, title: Text("深色模式")),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                // 保存设置
                _appSettingsController.themeMode.value = themeMode;
                _appSettingsController.saveSettings();
                Get.back();
              },
              child: Text("确认"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
      child: Row(
        children: [Text(title, style: TextStyle(color: Color(0xFF9A9A9A)))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("设置")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSettingGroupTitle("主题设置"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Obx(() {
                return SettingItemGroup(
                  settingItems: [
                    SettingItem(
                      title: Text("主题模式"),
                      tail: TextButton(
                        onPressed: () {
                          _showThemeChangeDialog();
                        },
                        child: Text(
                          _themeModeName(
                            _appSettingsController.themeMode.value,
                          ),
                        ),
                      ),
                      onTap: () {
                        _showThemeChangeDialog();
                      },
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
