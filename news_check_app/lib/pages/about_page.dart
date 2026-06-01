import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_check_app/theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("关于")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // App 图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.primaryDark, AppColors.primary]
                      : [AppColors.primaryAccent, AppColors.primary],
                ),
              ),
              child: const Icon(Icons.code_rounded, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              "开发者资讯",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "v1.0.0",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "OSCHINA IT 资讯 App 是一款基于 Flutter 构建的移动端应用，"
                "集成 OSCHINA OpenAPI，提供新闻、博客等开发者资讯的浏览与搜索功能。",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            // 技术栈卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _infoTile(context, Icons.phone_android_outlined, "前端", "Flutter + GetX"),
                    const Divider(height: 1, indent: 56),
                    _infoTile(context, Icons.dns_outlined, "后端", "Python FastAPI"),
                    const Divider(height: 1, indent: 56),
                    _infoTile(context, Icons.storage_outlined, "数据源", "OSCHINA OpenAPI"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // GitHub 链接（复制到剪贴板）
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(const ClipboardData(text: "https://github.com/your-repo"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("GitHub 链接已复制")),
                );
              },
              icon: const Icon(Icons.code),
              label: const Text("GitHub"),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}