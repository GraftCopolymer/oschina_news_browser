import 'package:flutter/material.dart';
import 'package:news_check_app/widgets/hero_page_route.dart';

mixin DetailImagePreviewMixin<T extends StatefulWidget> on State<T> {
  void handleImageClick(BuildContext context, GlobalKey webKey, Map<String, dynamic> data) {
    final url = data['src'] as String;
    final RenderBox? box = webKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final offset = box.localToGlobal(Offset.zero);
    final ratio = MediaQuery.of(context).devicePixelRatio;

    final rect = Rect.fromLTWH(
      (data['x'] / ratio) + offset.dx,
      (data['y'] / ratio) + offset.dy,
      data['width'] / ratio,
      data['height'] / ratio,
    );

    Navigator.of(context).push(HeroPhotoOverlayRoute(imageRect: rect, imageUrl: url));
  }
}