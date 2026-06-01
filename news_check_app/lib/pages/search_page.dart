import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/search_history_controller.dart';
import 'package:news_check_app/widgets/search_history_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();

  final List<String> _catalogs = ["新闻", "博客", "项目"];
  int _selectedCatalogIndex = 0;

  Widget _buildSearchCatalogItem(
    String text,
    void Function() onTap,
    bool isSelected,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: isSelected
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              )
            : Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(100),
                width: 2.0,
              ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(child: Text(text, style: TextStyle(fontSize: 16.0))),
          ),
          Positioned.fill(
            child: Material(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withAlpha(100)
                  : Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha(60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCatalogItemList() {
    List<Widget> result = [];
    for (int i = 0; i < _catalogs.length; i++) {
      result.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchCatalogItem(_catalogs[i], () {
              setState(() {
                _selectedCatalogIndex = i;
              });
            }, _selectedCatalogIndex == i),
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: SearchHistoryController(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(height: kToolbarHeight),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: "搜索${_catalogs[_selectedCatalogIndex]}",
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // 添加到搜索记录
                        if (_textController.text.isNotEmpty) {
                          controller.addHistory(_textController.text);
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(children: _buildCatalogItemList()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(children: [Text("搜索记录")]),
              ),
              // 搜索历史记录
              SearchHistoryWidget(controller: controller, onHistoryClick: (content) {
                debugPrint("点击了搜索历史记录: $content");
              },),
            ],
          );
        },
      ),
    );
  }
}
