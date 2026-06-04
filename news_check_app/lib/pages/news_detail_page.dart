import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/reading_settings_controller.dart';
import 'package:news_check_app/database/cache_dao.dart';
import 'package:news_check_app/database/read_history_dao.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/mixins/detail_image_preview_mixin.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/pages/common_detail_webview.dart';
import 'package:news_check_app/utils/image_download_service.dart';
import 'package:news_check_app/utils/passage_utils.dart';
import 'package:news_check_app/widgets/detail_bottom_bar.dart';
import 'package:news_check_app/widgets/detail_progress_bar.dart';
import 'package:news_check_app/widgets/reading_settings_sheet.dart';
import 'package:news_check_app/widgets/shimmer_loading.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key, required this.newsId});

  final int newsId;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>
    with DetailImagePreviewMixin {
  NewsDetail? _detail;
  bool _loading = true;

  final _webViewKey = GlobalKey();

  // 阅读进度
  int _readProgress = 0;
  // 底部栏可见性
  bool _showBottomBar = true;
  int _lastScrollTop = 0;
  // TOC
  List<TocEntry> _tocEntries = [];
  final _scrollToTocNotifier = ValueNotifier<String?>(null);
  // 元信息
  int _wordCount = 0;
  int _estimatedMinutes = 1;

  final _settingsCtrl = Get.find<ReadingSettingsController>();

  Future<void> _initData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    // 先查缓存
    final cached = await CacheDao.get('news', widget.newsId);
    if (cached != null) {
      final detail = NewsDetail(
        id: cached.itemId,
        title: cached.title,
        author: cached.author,
        pubDate: cached.pubDate,
        body: cached.localBody ?? cached.body,
        authorid: 0,
      );
      final count = PassageUtils.countReadableChars(detail.body);
      if (mounted) {
        setState(() {
          _detail = detail;
          _loading = false;
          _wordCount = count;
          _estimatedMinutes = (count / 300).ceil().clamp(1, 999);
        });
      }
    }

    try {
      final resp = await api.newsDetailIdGet(id: widget.newsId);
      final body = resp.data as Map<String, dynamic>?;
      if (resp.statusCode != 200 || body == null) {
        if (cached == null) Fluttertoast.showToast(msg: "获取新闻信息失败 ${resp.statusCode}");
        return;
      }
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        if (cached == null) Fluttertoast.showToast(msg: "错误 数据未正常发送");
        return;
      }
      final newsDetail = NewsDetail.fromJson(data['news_detail']);
      final wordCount = PassageUtils.countReadableChars(newsDetail.body);
      await CacheDao.insert(
        type: 'news', id: newsDetail.id, title: newsDetail.title,
        author: newsDetail.author, pubDate: newsDetail.pubDate, body: newsDetail.body,
      );
      await ReadHistoryDao.recordRead(
        type: 'news', id: newsDetail.id, title: newsDetail.title, wordCount: wordCount,
      );
      final imageUrls = PassageUtils.extractImageUrls(newsDetail.body);
      if (imageUrls.isNotEmpty) {
        ImageDownloadService.instance.enqueueImageDownloads('news_${newsDetail.id}', imageUrls);
      }
      if (mounted) {
        setState(() {
          _detail = newsDetail;
          _wordCount = wordCount;
          _estimatedMinutes = (wordCount / 300).ceil().clamp(1, 999);
        });
      }
    } catch (e) {
      if (cached == null) {
        Fluttertoast.showToast(msg: "发生错误");
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _onProgressChanged(int progress) {
    if (progress == -1) return; // 忽略测试消息
    if (_readProgress != progress) {
      setState(() {
        _readProgress = progress;
      });
    }
  }

  void _onScrollChanged(int scrollTop) {
    if (scrollTop == -1) return;
    final delta = scrollTop - _lastScrollTop;
    if (delta.abs() > 10) {
      if (delta > 0 && _showBottomBar) {
        setState(() => _showBottomBar = false);
      } else if (delta < 0 && !_showBottomBar) {
        setState(() => _showBottomBar = true);
      }
    }
    _lastScrollTop = scrollTop;
  }

  void _showToc() {
    if (_tocEntries.isEmpty) {
      Fluttertoast.showToast(msg: "本文无目录");
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('文章目录', style: theme.textTheme.titleMedium),
            ),
            ..._tocEntries.map((e) => ListTile(
              leading: Text('H${e.level}',
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.w500)),
              title: Text(e.text, maxLines: 2, overflow: TextOverflow.ellipsis),
              dense: true,
              onTap: () {
                Get.back();
                _scrollToTocNotifier.value = e.id;
              },
            )),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _scrollToTocNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("详情"),
      ),
      body: _loading && _detail == null
          ? const Center(child: ShimmerCard())
          : _detail == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text("加载失败"),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initData,
                        style: ElevatedButton.styleFrom(minimumSize: const Size(120, 40)),
                        child: const Text("重试"),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // WebView 填满整个 body
                    Positioned.fill(child: _buildWebView()),

                    // 顶部悬浮层：进度条 + 元信息
                    Positioned(
                      top: 0, left: 0, right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DetailProgressBar(progress: _readProgress / 100.0),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topCenter,
                            child: _showBottomBar
                                ? Container(
                                    color: colorScheme.surface,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: colorScheme.primaryContainer,
                                            child: Text(
                                              _detail!.author.isNotEmpty ? _detail!.author[0] : '?',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: colorScheme.onPrimaryContainer,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(_detail!.author,
                                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                                Text(
                                                  '${_detail!.pubDate} · 约 $_estimatedMinutes 分钟 · $_wordCount 字',
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                )
                                : const SizedBox(width: double.infinity, height: 0),
                          ),
                        ],
                      ),
                    ),

                    // 底部悬浮层：操作栏
                    Positioned(
                      left: 0, right: 0, bottom: 0,
                      child: DetailBottomBar(
                        isVisible: _showBottomBar,
                        onFontSettings: () => showReadingSettingsSheet(context),
                        onToc: _showToc,
                        onBookmark: () => Fluttertoast.showToast(msg: "收藏功能开发中"),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildWebView() {
    final (htmlContent, toc) = PassageUtils.wrapBodyForWebView(
      title: _detail!.title,
      author: _detail!.author,
      pubDate: _detail!.pubDate,
      body: _detail!.body,
      isDark: Get.isDarkMode,
      fontSize: _settingsCtrl.fontSize.value,
      lineSpacing: _settingsCtrl.lineSpacing.value,
    );
    _tocEntries = toc;
    _wordCount = PassageUtils.countReadableChars(_detail!.body);
    _estimatedMinutes = (_wordCount / 300).ceil().clamp(1, 999);

    return CommonDetailWebView(
      htmlContent: htmlContent,
      webViewKey: _webViewKey,
      tocEntries: _tocEntries,
      scrollToTocNotifier: _scrollToTocNotifier,
      onTap: () => setState(() => _showBottomBar = !_showBottomBar),
      onImageClick: (data) {
        handleImageClick(context, _webViewKey, data);
      },
      onProgressChanged: _onProgressChanged,
      onScrollChanged: _onScrollChanged,
    );
  }
}