import 'package:flutter/material.dart';

class DetailBottomBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onFontSettings;
  final VoidCallback onToc;
  final VoidCallback onBookmark;
  final bool isFavorited;

  const DetailBottomBar({
    super.key,
    required this.isVisible,
    required this.onFontSettings,
    required this.onToc,
    required this.onBookmark,
    this.isFavorited = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BarButton(
                    icon: Icons.text_fields,
                    label: '字号',
                    onTap: onFontSettings,
                  ),
                  _BarButton(
                    icon: Icons.list_alt,
                    label: '目录',
                    onTap: onToc,
                  ),
                  _BarButton(
                    icon: isFavorited ? Icons.bookmark : Icons.bookmark_border,
                    label: '收藏',
                    color: isFavorited ? const Color(0xFF0D9488) : null,
                    onTap: onBookmark,
                  ),
                  _BarButton(
                    icon: Icons.share_outlined,
                    label: '分享',
                    onTap: null,
                    disabled: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool disabled;
  final Color? color;

  const _BarButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.disabled = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = disabled
        ? (color ?? colorScheme.onSurface).withAlpha(80)
        : (color ?? colorScheme.onSurface);
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: foreground),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: foreground)),
          ],
        ),
      ),
    );
  }
}