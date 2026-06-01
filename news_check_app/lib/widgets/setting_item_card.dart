import 'package:flutter/material.dart';

class SettingItemCard extends StatelessWidget {
  const SettingItemCard({
    super.key,
    required this.title,
    required this.tail,
    required this.onTap,
    this.topLeft = 12.0,
    this.topRight = 12.0,
    this.bottomLeft = 12.0,
    this.bottomRight = 12.0,
  });

  final Widget tail;
  final Widget title;

  // 圆角
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  // 点击事件
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeft),
              topRight: Radius.circular(topRight),
              bottomLeft: Radius.circular(bottomLeft),
              bottomRight: Radius.circular(bottomRight),
            ),
            child: InkWell(
              onTap: () {
                onTap();
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DefaultTextStyle(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 16.0),
                child: title,
              ),
              DefaultTextStyle(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 14.0),
                child: tail,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
