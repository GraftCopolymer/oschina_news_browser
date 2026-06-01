import 'package:flutter/material.dart';
import 'package:news_check_app/widgets/setting_item_card.dart';

class SettingItemGroup extends StatelessWidget {
  const SettingItemGroup({super.key, required this.settingItems, this.addDivider=true});

  final List<SettingItem> settingItems;
  final bool addDivider;

  List<Widget> _buildSettingCards() {
    final result = <Widget>[];
    for (int i = 0; i < settingItems.length; i++) {
      late double topLeft;
      late double topRight;
      late double bottomLeft;
      late double bottomRight;
      if (i == 0 && settingItems.length == 1) {
        topLeft = 12.0;
        topRight = 12.0;
        bottomLeft = 12.0;
        bottomRight = 12.0;
      } else if (i == 0 && settingItems.length > 1) {
        topLeft = 12.0;
        topRight = 12.0;
        bottomLeft = 0;
        bottomRight = 0;
      } else if (i > 0 && i != settingItems.length - 1) {
        topLeft = 0;
        topRight = 0;
        bottomLeft = 0;
        bottomRight = 0;
      } else {
        topLeft = 0;
        topRight = 0;
        bottomLeft = 12.0;
        bottomRight = 12.0;
      }
      final settingItem = settingItems[i];
      result.add(
        SettingItemCard(
          tail: settingItem.tail,
          title: settingItem.title,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
          onTap: () {
            settingItem.onTap();
          },
        ),
      );
      if (addDivider && i < settingItems.length - 1) {
        // 添加分割线
        result.add(
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.withAlpha(33),
          )
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(33),
            blurRadius: 6.0,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      // margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: _buildSettingCards(),
      ),
    );
  }
}

class SettingItem {
  const SettingItem({
    required this.tail,
    required this.title,
    required this.onTap,
  });

  final Widget tail;
  final Widget title;
  // 点击事件
  final Function() onTap;
}
