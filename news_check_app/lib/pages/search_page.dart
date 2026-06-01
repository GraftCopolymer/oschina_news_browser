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
  final _focusNode = FocusNode();

  final List<String> _catalogs = ["新闻", "博客", "项目"];
  int _selectedCatalogIndex = 0;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showHistory = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("搜索")),
      body: GetBuilder(
        init: SearchHistoryController(),
        builder: (controller) {
          return Column(
            children: [
              // 搜索框
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: "搜索${_catalogs[_selectedCatalogIndex]}",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _textController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _textController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withAlpha(80),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.addHistory(value);
                    }
                  },
                ),
              ),
              // 目录选择 ChoiceChip
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(_catalogs.length, (i) {
                    final isSelected = _selectedCatalogIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_catalogs[i]),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCatalogIndex = i;
                            });
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              // 搜索历史
              if (_showHistory || controller.history.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        "搜索记录",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      if (controller.history.isNotEmpty)
                        TextButton(
                          onPressed: () => controller.clearHistory(),
                          child: const Text("清除全部"),
                        ),
                    ],
                  ),
                ),
              if (_showHistory)
                Expanded(
                  child: SearchHistoryWidget(
                    controller: controller,
                    onHistoryClick: (content) {
                      _textController.text = content;
                      debugPrint("点击搜索历史: $content");
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}