import 'package:flutter/material.dart';
import 'package:news_check_app/models/models.dart';

class BlogSimpleCard extends StatelessWidget {
  const BlogSimpleCard({super.key, required this.blog, this.onTap});

  final BlogSimple blog;
  final Function(BlogSimple blog)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(blog);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(blog.pubDate, style: const TextStyle(color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  blog.title,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${blog.commentCount} 评论",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 5),
                  Text("作者: ${blog.author}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}