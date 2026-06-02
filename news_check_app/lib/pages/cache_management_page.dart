import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/offline_cache_controller.dart';
import 'package:news_check_app/database/cache_dao.dart';
import 'package:news_check_app/pages/blog_detail_page.dart';
import 'package:news_check_app/pages/news_detail_page.dart';

class CacheManagementPage extends StatefulWidget {
  const CacheManagementPage({super.key});

  @override
  State<CacheManagementPage> createState() => _CacheManagementPageState();
}

class _CacheManagementPageState extends State<CacheManagementPage> {
  List<CacheItem> _items = [];
  bool _loading = true;
  bool _editMode = false;
  final Set<String> _selected = {};
  int _cacheSize = 0;

  final _cacheCtrl = Get.find<OfflineCacheController>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await CacheDao.getAll();
    final size = await CacheDao.getTotalSize();
    if (mounted) {
      setState(() {
        _items = items;
        _cacheSize = size;
        _loading = false;
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
      if (!_editMode) _selected.clear();
    });
  }

  void _toggleSelection(String key) {
    setState(() {
      if (_selected.contains(key)) {
        _selected.remove(key);
      } else {
        _selected.add(key);
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (_selected.isEmpty) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("删除缓存"),
        content: Text("确定要删除选中的 ${_selected.length} 条缓存吗？"),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("取消")),
          TextButton(onPressed: () => Get.back(result: true), child: const Text("确定")),
        ],
      ),
    );
    if (confirm != true) return;

    for (final key in _selected) {
      final parts = key.split('_');
      if (parts.length >= 2) {
        final type = parts[0];
        final id = int.tryParse(parts[1]);
        if (id != null) {
          await CacheDao.delete(type, id);
        }
      }
    }
    _selected.clear();
    await _cacheCtrl.refreshCachedKeys();
    await _cacheCtrl.refreshCacheSize();
    await _load();
  }

  void _openItem(CacheItem item) {
    if (_editMode) {
      _toggleSelection('${item.itemType}_${item.itemId}');
      return;
    }
    if (item.itemType == 'news') {
      Get.to(() => NewsDetailPage(newsId: item.itemId));
    } else {
      Get.to(() => BlogDetailPage(blogId: item.itemId));
    }
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }

  String _formatDate(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} 分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} 小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} 天前';
    }
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("缓存管理"),
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              icon: Icon(_editMode ? Icons.close : Icons.checklist),
              tooltip: _editMode ? '完成' : '选择',
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off, size: 64,
                          color: colorScheme.onSurfaceVariant.withAlpha(80)),
                      const SizedBox(height: 12),
                      Text(
                        "暂无缓存内容",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "阅读新闻或博客后，内容会自动缓存至此",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // 顶部统计
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: colorScheme.surfaceContainerHighest.withAlpha(60),
                      child: Row(
                        children: [
                          Icon(Icons.storage, size: 16, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(
                            '共 ${_items.length} 篇 · ${_formatSize(_cacheSize)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          if (_editMode && _selected.isNotEmpty)
                            Text(
                              '已选 ${_selected.length} 项',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // 列表
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final key = '${item.itemType}_${item.itemId}';
                            final isSelected = _selected.contains(key);

                            return ListTile(
                              leading: _editMode
                                  ? Checkbox(
                                      value: isSelected,
                                      onChanged: (_) => _toggleSelection(key),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: item.itemType == 'news'
                                          ? const Color(0xFF0D9488).withAlpha(30)
                                          : const Color(0xFF7C3AED).withAlpha(30),
                                      child: Icon(
                                        item.itemType == 'news'
                                            ? Icons.article_outlined
                                            : Icons.edit_note,
                                        size: 18,
                                        color: item.itemType == 'news'
                                            ? const Color(0xFF0D9488)
                                            : const Color(0xFF7C3AED),
                                      ),
                                    ),
                              title: Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                '${item.itemType == 'news' ? '新闻' : '博客'} · ${item.author} · ${_formatDate(item.cachedAt)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: _editMode
                                  ? null
                                  : Icon(Icons.chevron_right, size: 18,
                                      color: colorScheme.onSurfaceVariant),
                              onTap: () => _openItem(item),
                              selected: isSelected,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      // 底部 FAB — 编辑模式下显示删除按钮
      floatingActionButton: _editMode && _selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _deleteSelected,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.delete_outline),
              label: Text('删除 (${_selected.length})'),
            )
          : null,
    );
  }
}