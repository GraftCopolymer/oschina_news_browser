import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/pages/search_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 12,
        bottom: 4,
      ),
      child: Row(
        children: [
          Text(
            "开发者资讯",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.to(() => const SearchPage()),
            icon: const Icon(Icons.search),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }
}