import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:news_check_app/controllers/search_history_controller.dart';

class SearchHistoryWidget extends StatefulWidget {
  const SearchHistoryWidget({super.key, required this.controller, required this.onHistoryClick});

  final SearchHistoryController controller;
  final void Function(String content) onHistoryClick;

  @override
  State<SearchHistoryWidget> createState() => _SearchHistoryWidgetState();
}

class _SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  late bool _isLoading;

  List<Widget> _buildHistoryChildren() {
    List<Widget> result = [];
    for (final history in widget.controller.history) {
      result.add(
        GestureDetector(
          onTap: () {
            widget.onHistoryClick(history);
          },
          child: Chip(
            label: Text(history),
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: () {
              widget.controller.removeHistory(history);
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
    _isLoading = !widget.controller.isCompleted();
    widget.controller.loadingFuture?.then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container();
    }
    return Obx(() {
      return Wrap(
        spacing: 10,
        runSpacing: 5.0,
        children: _buildHistoryChildren(),
      );
    });
  }
}
