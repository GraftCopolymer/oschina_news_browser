import 'package:flutter/material.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({
    super.key,
    required this.onPageChanged,
    required this.tabs,
    this.currentIndex = 0,
  });

  final Function(int oldIndex, int newIndex) onPageChanged;
  final List<MyNavigationBarItem> tabs;
  final int currentIndex;

  @override
  State<MyNavigationBar> createState() {
    return _MyNavigationBarState();
  }
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  late int _currentIndex;

  List<Widget> _buildTabEntry() {
    List<Widget> result = [];
    for (int i = 0; i < widget.tabs.length; i++) {
      result.add(
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    widget.onPageChanged(_currentIndex, i);
                    setState(() {
                      _currentIndex = i;
                    });
                  },
                  child: _currentIndex == i
                      ? widget.tabs[i].activeIcon
                      : widget.tabs[i].icon,
                ),
              );
            },
          ),
        ),
      );
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 80,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          debugPrint("最大高度: ${constraints.maxHeight}");
          return SizedBox(
            height: constraints.maxHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: constraints.maxHeight - paddingBottom, child: Row(children: _buildTabEntry())),
                SizedBox(height: paddingBottom,)
              ],
            ),
          );
        },
      ),
    );
  }
}

class MyNavigationBarItem {
  MyNavigationBarItem({required this.icon, required this.activeIcon});

  final Widget icon;
  final Widget activeIcon;
}
