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
      final isSelected = _currentIndex == i;
      result.add(
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.onPageChanged(_currentIndex, i);
              setState(() {
                _currentIndex = i;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isSelected
                    ? widget.tabs[i].activeIcon
                    : widget.tabs[i].icon,
                if (widget.tabs[i].label != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.tabs[i].label!,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
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
      height: 64 + paddingBottom,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: paddingBottom),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      child: Row(children: _buildTabEntry()),
    );
  }
}

class MyNavigationBarItem {
  MyNavigationBarItem({required this.icon, required this.activeIcon, this.label});

  final Widget icon;
  final Widget activeIcon;
  final String? label;
}
