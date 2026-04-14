import 'package:flutter/material.dart';
import 'package:news_check_app/models/models.dart';

class NewsSimpleCard extends StatelessWidget {
  const NewsSimpleCard({super.key, required this.news, this.onTap});

  final NewsSimple news;
  final Function(NewsSimple news)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(news);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(news.pubDate, style: TextStyle(color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  news.title,
                  style: TextStyle(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${news.commentCount} 评论",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 5),
                  Text("作者: ${news.author}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
