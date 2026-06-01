# 前端 UI 美化设计方案

**日期**: 2026-06-01
**项目**: OSCHINA IT 资讯 App (Flutter 前端 + FastAPI 后端)

## 设计目标

将当前基于 Flutter 默认 ThemeData 的 MVP 界面，优化为具有品牌识别度的现代资讯风格 App，提升视觉层次、阅读体验和交互质感。

## 设计决策

| 决策项 | 选择 | 理由 |
|--------|------|------|
| 设计风格 | 现代资讯风（参考 36氪/少数派） | 注重信息层级、留白、卡片化、大标题 |
| 主色调 | 青蓝 (Teal-600 #0D9488) | 年轻有活力，符合开发者社区定位 |
| 列表布局 | 不规则瀑布流 Grid（小红书风格） | 视觉丰富，不依赖封面图也能有节奏感 |
| 封面图 | 渐变背景色块替代（API 不提供封面图） | OSCHINA news_list/blog_list 无任何图片字段 |

## 技术约束

- OSCHINA API 不提供新闻/博客列表的封面图字段（已验证 `backend/oschina接口文档.html`）
- 后端 Pydantic 模型（`NewsSimple`, `BlogSimple`）只有 `id, author, pubDate, title, authorid, commentCount, type`
- 现有 Flutter 项目使用 GetX、Dio、freezed、WebView

## 1. 主题系统重构

### 1.1 颜色系统

**新建 `lib/theme/app_colors.dart`：**

```dart
// 主色调 - 青蓝
const primaryLight = Color(0xFF0D9488);    // Teal-600
const primaryDark  = Color(0xFF0F766E);    // Teal-700
const primaryAccent = Color(0xFF14B8A6);   // Teal-500

// 辅助色
const accentOrange = Color(0xFFF59E0B);
const bgLight = Color(0xFFF8FAFC);
const bgDark  = Color(0xFF1E293B);
const textPrimary = Color(0xFF1E293B);
const textDark = Color(0xFFF1F5F9);
const textSecondary = Color(0xFF94A3B8);
```

### 1.2 ThemeData 工厂

**新建 `lib/theme/app_theme.dart`：**

- 使用 `ColorScheme.fromSeed(seedColor: Color(0xFF0D9488))` 生成完整的亮色/暗色色板
- 自定义 `CardTheme`：elevation 1, borderRadius 12, margin 水平 16
- 自定义 `AppBarTheme`：scrolledUnderElevation 0, backgroundColor transparent
- 自定义 `TextTheme`：各层级字号/字重，标题使用大号加粗
- 自定义 `ChipTheme`：圆角 chip, selected 填充色
- 自定义 `InputDecorationTheme`：圆角边框，12px radius
- 自定义 `ElevatedButtonTheme`：大圆角，高度 48

### 1.3 集成

- `main.dart`：`GetMaterialApp.theme` / `darkTheme` 替换为自定义 ThemeData
- `app_settings_controller.dart`：使用自定义 ThemeData
- 逐步移除所有文件中硬编码的颜色值

## 2. 首页布局重构

### 2.1 移除空白 AppBar

当前 `home_page.dart` 使用 `toolbarHeight: 0` 的空 AppBar 导致顶部有空白区域。

改造方案：
- 去掉该 AppBar
- 使用自定义 Header 组件：上边距安全区，左侧 "开发者资讯" 大标题，右侧搜索图标

### 2.2 自定义 Header

**新建 `lib/widgets/home_header.dart`：**

- 高度 56 + safe area top padding
- 左侧：粗体大标题 "开发者资讯"（字号 22, FontWeight.w700）
- 右侧：搜索图标按钮（点击跳转 SearchPage）
- 背景色：透明（TabBar 上方悬浮效果）

### 2.3 TabBar 优化

- 保留 TabBar，但增加自定义样式
- 选中标签下划线改用青蓝 `Container(height: 3, borderRadius: 2)`
- 标签文字：选中时粗体，未选中时常规

## 3. 瀑布流卡片布局

### 3.1 添加依赖

- `flutter_staggered_grid_view: ^0.7.0`

### 3.2 新闻卡片

**新建 `lib/widgets/staggered_news_card.dart`：**

- 使用 `MasonryGridView.count(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12)` 包装
- 卡片高度差异化（200px / 250px / 280px 三档）：短标题（≤25字符）用 200px，中等用 250px，长标题用 280px，同屏混合排列
- **渐变背景色块**替代封面图，预定义 4 种渐变组合，按卡片 `type` 字段分配：
  - 青蓝渐变 (Teal-400 → Teal-600)
  - 紫色渐变 (Purple-400 → Purple-600)
  - 暖橙渐变 (Amber-400 → Orange-500)
  - 灰白渐变 (Slate-100 → Slate-200)
- 左上角：圆角标签（`Container(borderRadius: 8)`），文字显示类型（"新闻" / "软件更新" / "综合" — 根据 `type` 字段映射）
- 标题：大号粗体（字号 16-18），最多 3 行
- 底部：日期（灰色）+ 评论数（带小图标）
- 整体圆角 16px，elevation 1

### 3.3 博客卡片

**新建 `lib/widgets/staggered_blog_card.dart`：**

- 结构与新闻卡片一致
- 标签显示 "原创" / "转载"（根据 BlogSimple.type: 1=原创, 4=转载）

### 3.4 改造 NewsTab / BlogTab

- `news_tab.dart` 和 `blog_tab.dart`：
  - `ListView.builder` → `MasonryGridView.builder`
  - 外层的 `RefreshIndicator` 保持不变
  - `ScrollController` 的 `addListener` 在到达底部时调用 `loadMore()` 的逻辑需要适配 GridView 的滚动判断
  - 保持 pull-to-refresh + infinite scroll

## 4. 登录页改造

**文件：`lib/pages/login_page.dart`**

新设计：
- 背景：青蓝到深蓝 `LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF1E3A5F)])`
- Logo：居中，放大到 100x100，使用 OSCHINA Logo 或文字标志
- "开发者资讯" 品牌文字（白色，字号 28, FontWeight.bold）
- "发现最新的技术资讯" 副标题（白色 60% 透明度）
- 登录按钮：白色背景，青蓝文字，大圆角（radius 24），高度 52，带 `Icons.arrow_forward`
- 底部文案："使用 OSCHINA 账号一键登录"（白色 50% 透明度）
- 进入动画：Logo fade-in 2s + 按钮 slide-up 0.5s

## 5. 个人中心页改造

**文件：`lib/pages/account_page.dart`**

### 5.1 已登录状态

- 顶部：渐变背景横幅（高度 180），底部对齐圆形头像
- 头像：放大到 80x80，白色边框 3px
- 用户名：字号 22, Bold，在头像下方
- 邮箱/用户 ID：灰色小字
- 统计数据行：三列（收藏 / 浏览 / 消息），数字 + 标签
- 功能列表卡片组（采用现有 `SettingItemGroup` 风格但增加 Icon）：
  - ⭐ 我的收藏
  - 🎨 主题设置 → 跳转设置页
  - ℹ️ 关于
- 退出按钮：单独一行，红色文字，圆角

### 5.2 未登录状态

- 同上渐变背景
- Logo + "尚未登录" 文字
- "去登录" 大按钮（与登录页风格统一）

## 6. 搜索页优化

**文件：`lib/pages/search_page.dart`**

- 目录选择器：`Stack`+`Material`+`InkWell` → 替换为 `ChoiceChip` 组件
- 搜索框：聚焦时自动展开搜索历史
- 搜索历史：`Wrap` of `Chip`，每个 Chip 带 `deleteIcon`（`Icons.close`），增加 "清除全部" 按钮
- 搜索结果：使用与瀑布流统一的卡片样式
- 搜索类型切换：微动画（AnimatedSwitcher）
- 空状态：插画 + "没有找到相关内容"

## 7. 详情页优化

**文件：`lib/pages/news_detail_page.dart`, `lib/pages/blog_detail_page.dart`**

- 加载中：**Shimmer 骨架屏**（灰色块闪烁动画，模拟 Card 布局）
- 错误状态：图标（`Icons.error_outline`）+ 文字 + 圆角重试按钮
- 内容渲染：保持不变（WebView / Markdown 渲染方式）

## 8. 全局加载状态优化

**新建 `lib/widgets/shimmer_loading.dart`：**

- Shimmer 动效组件，复用 `shimmer` 思路（AnimatedBuilder + 渐变遮罩移动）
- `ShimmerCard` 组件：模拟卡片形状的灰色块
- `ShimmerGrid` 组件：模拟 2 列瀑布流的骨架屏

**替换现有：**
- 所有 `CircularProgressIndicator` → 对应 `ShimmerGrid` 或 `ShimmerCard`
- 空数据/网络错误增加 `EmptyStateWidget`（带图标 + 文案 + 操作按钮）

## 9. 动效

### 9.1 列表项进入动画

- `SlideTransition` + `FadeTransition`：每项从下方 20px 渐入
- 延迟递增（`interval` 控制），呈现逐项滑入效果

### 9.2 页面过渡

- 保持现有 `HeroPhotoOverlayRoute` 的图片放大功能
- 页面间切换使用 `PageRouteBuilder` 自定义 push 动画（右滑入）

### 9.3 底部导航切换

- 选中图标添加 `ScaleTransition` 微缩放动画
- Tab 切换平滑动画（系统默认）

## 10. 文件变更清单

| 操作 | 文件 | 说明 |
|------|------|------|
| 新建 | `lib/theme/app_colors.dart` | 颜色常量集中管理 |
| 新建 | `lib/theme/app_theme.dart` | 自定义 ThemeData 工厂 |
| 新建 | `lib/widgets/staggered_news_card.dart` | 新闻瀑布流卡片 |
| 新建 | `lib/widgets/staggered_blog_card.dart` | 博客瀑布流卡片 |
| 新建 | `lib/widgets/home_header.dart` | 首页自定义 Header |
| 新建 | `lib/widgets/shimmer_loading.dart` | 骨架屏组件 |
| 修改 | `lib/main.dart` | 替换 ThemeData 为自定义主题 |
| 修改 | `lib/controllers/app_settings_controller.dart` | 适配自定义主题 |
| 修改 | `lib/pages/home_page.dart` | 加 Header + TabBar 优化 |
| 修改 | `lib/pages/news_tab.dart` | ListView → MasonryGridView |
| 修改 | `lib/pages/blog_tab.dart` | ListView → MasonryGridView |
| 修改 | `lib/pages/login_page.dart` | 渐变背景 + 大按钮 + 动画 |
| 修改 | `lib/pages/account_page.dart` | 横幅头像 + 统计 + 卡片列表 |
| 修改 | `lib/pages/search_page.dart` | ChoiceChip + 历史管理 |
| 修改 | `lib/pages/news_detail_page.dart` | 骨架屏 + 错误状态 |
| 修改 | `lib/pages/blog_detail_page.dart` | 骨架屏 + 错误状态 |
| 修改 | `pubspec.yaml` | 添加 `flutter_staggered_grid_view` |

## 11. 影响范围

- **不影响后端**：所有改动在 Flutter 前端
- **不影响现有功能**：认证、WebView 详情、搜索、收藏逻辑不变
- **不修改数据模型**：`NewsSimple` / `BlogSimple` 字段不变，仅前端展示方式变化