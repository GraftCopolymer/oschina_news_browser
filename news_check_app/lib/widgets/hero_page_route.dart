import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoOverlayRoute extends PageRouteBuilder {
  final Rect imageRect;
  final String imageUrl;

  HeroPhotoOverlayRoute({required this.imageRect, required this.imageUrl})
    : super(
        // 关键：设置为透明，这样动画开始时能看到 WebView
        opaque: false,
        fullscreenDialog: true,
        barrierColor: null, // 初始背景透明
        transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 0),
        pageBuilder: (context, animation, secondaryAnimation) {
          return _HeroPhotoOverlay(imageUrl: imageUrl, initialRect: imageRect);
        },
      );
}

/// 图片 Hero 动画中间页
class _HeroPhotoOverlay extends StatefulWidget {
  const _HeroPhotoOverlay({
    super.key,
    required this.imageUrl,
    required this.initialRect,
  });

  final String imageUrl;
  final Rect initialRect; // 图片初始位置

  @override
  State<_HeroPhotoOverlay> createState() => _HeroPhotoOverlayState();
}

class _HeroPhotoOverlayState extends State<_HeroPhotoOverlay> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          barrierDismissible: false,
          pageBuilder: (context, _, _) {
            return _HeroPhotoViewer(imageUrl: widget.imageUrl);
          },
          transitionDuration: Duration(milliseconds: 300),
          reverseTransitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final backgroundColor =
                ColorTween(
                  begin: Colors.transparent,
                  end: Colors.black54, // 最终的遮罩颜色
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );
            return AnimatedBuilder(
              animation: backgroundColor,
              builder: (context, child) {
                return Container(
                  color: backgroundColor.value,
                  child: child,
                );
              },
              child: child,
            );
          },
        ),
      );
      await Future.delayed(Duration(milliseconds: 300));
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 关键：使用 Stack 和 Positioned 来占位，模拟从 WebView 弹出的效果
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. 动画起始点的占位 Hero
          Positioned.fromRect(
            rect: widget.initialRect,
            child: Hero(
              tag: widget.imageUrl, // 使用图片 URL 作为唯一 tag
              // 这是一个关键技巧：如果图片很大，飞过去的过程中可能需要自定义 placeholder
              child: Image.network(widget.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPhotoViewer extends StatefulWidget {
  const _HeroPhotoViewer({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<_HeroPhotoViewer> createState() => __HeroPhotoViewerState();
}

class __HeroPhotoViewerState extends State<_HeroPhotoViewer> {
  late final PhotoViewScaleStateController _controller;

  void _resetPhotoScale() {
    // PhotoView 本身对 controller.scale 的赋值是瞬间的
    // 如果想要平滑动画，可以使用下面的方式
    _controller.scaleState = PhotoViewScaleState.initial;
    // 如果需要更丝滑的动画，建议配合 PhotoViewScaleStateController 使用
  }

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewScaleStateController();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // 检查当前图片缩放是否是 1
        if (_controller.scaleState != PhotoViewScaleState.initial) {
          _resetPhotoScale();
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: PhotoView(
                scaleStateController: _controller,
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                imageProvider: NetworkImage(widget.imageUrl),
                heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                onTapUp: (context, details, controllerValue) {
                  if (_controller.scaleState == PhotoViewScaleState.initial) {
                    Get.back();
                  } else {
                    _resetPhotoScale();
                  }
                },
              ),
            ),
      
            // 关闭按钮
            Positioned(
              top: 40,
              left: 20,
              child: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
