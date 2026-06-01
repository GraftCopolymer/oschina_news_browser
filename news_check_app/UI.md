# OSCHINA IT 资讯 App — UI 设计规范

> 本文档记录前端 UI 的设计风格、配色系统、组件规范和交互约定。在对 UI 进行修改或扩展时应参考本文档，保持风格一致。

## 设计风格

- **定位**: 现代资讯风，参考 36氪 / 少数派
- **核心理念**: 干净留白、卡片化、大标题、信息层级清晰
- **目标用户**: 开发者 / IT 从业者

## 配色系统

### 主色调 — 青蓝 (Teal)

| 用途 | 色值 | 说明 |
|------|------|------|
| 主色 | `#0D9488` | Teal-600，按钮、选中态、强调 |
| 主色深色变体 | `#0F766E` | Teal-700，暗色模式主色 |
| 主色强调 | `#14B8A6` | Teal-500，渐变亮端 |
| 主色淡色 | `#CCFBF1` | Teal-100，标签浅背景 |

### 辅助色

| 用途 | 色值 | 说明 |
|------|------|------|
| 暖橙强调 | `#F59E0B` | 标签/特殊强调 |
| 背景 (亮) | `#F8FAFC` | Scaffold 背景色 |
| 背景 (暗) | `#1E293B` | 暗色模式背景色 |
| 文字主色 (亮) | `#1E293B` | |
| 文字主色 (暗) | `#F1F5F9` | |
| 文字次要 | `#94A3B8` | 灰色辅助文字 |

### 卡片渐变

卡片背景不使用图片，改用彩色渐变。预定义 4 组渐变，按 `type` 字段分配：

| 渐变 | 亮色模式 | 暗色模式 | 对应 type |
|------|---------|---------|----------|
| 青蓝 | `#14B8A6` → `#0D9488` | `#0F766E` → `#0D9488` | 0(链接), 3(博客), 7(翻译) |
| 紫色 | `#A855F7` → `#7C3AED` | `#6B21A8` → `#7C3AED` | 1(软件), 5(预留) |
| 暖橙 | `#FBBF24` → `#F59E0B` | `#B45309` → `#D97706` | 2(讨论), 6(预留) |
| 灰白 | `#E2E8F0` → `#CBD5E1` | `#334155` → `#475569` | 4(普通新闻) |

**文字颜色规则**: 使用 `Color.computeLuminance()` 检测渐变亮度，浅色渐变自动用深色文字（`Colors.black87`），深色渐变用白色文字。

## 字体排版

| 层级 | 字号 | 字重 | 用途 |
|------|------|------|------|
| headlineLarge | 28 | w700 | 大标题（极少使用） |
| headlineMedium | 22 | w700 | 页面标题 |
| titleLarge | 18 | w600 | 新闻/博客卡片标题 |
| titleMedium | 16 | w500 | 列表项标题 |
| bodyLarge | 16 | normal | 正文 |
| bodyMedium | 14 | normal | 辅助文字 |
| labelLarge | 14 | w500 | 按钮/标签文字 |

## 组件规范

### 卡片（Card）
- elevation: 1
- borderRadius: 12
- margin: horizontal 16

### 按钮（ElevatedButton）
- 最小尺寸: `double.infinity` × 48
- borderRadius: 24（大圆角）
- 字号: 16, w600

### 输入框（TextField）
- border: OutlineInputBorder, borderRadius: 12
- padding: horizontal 16, vertical 14

### Chip
- borderRadius: 20（椭圆）
- padding: horizontal 12, vertical 6

### 瀑布流卡片（StaggeredNewsCard / StaggeredBlogCard）
- borderRadius: 16
- 高度: 200 / 250 / 280px 三档（按标题长度分配）
- 标题 ≤25 字符 → 200px
- 标题 26-40 字符 → 250px
- 标题 >40 字符 → 280px
- 左上角: 圆角类型标签（6px）
- 内容: 渐变背景 + 白色/深色文字 + 底部信息行（评论数 + 作者 + 日期）
- 阴影: 渐变色最后一位 withAlpha(60), blur 8, offset y 4

### 底部导航（MyNavigationBar）
- 高度: 64 + safeAreaBottom
- 图标大小: 28
- 标签文字: 10px, 选中时 primary 色 + w600
- 顶部: 0.5px 灰色分割线

### 骨架屏（Shimmer）
- 动画时长: 1500ms
- 渐变: base → highlight → base 循环移动
- 亮色模式: grey.shade300 → grey.shade100
- 暗色模式: grey.shade800 → grey.shade700
- 两种形态: ShimmerCard（详情页）、ShimmerGrid（列表页）

## 页面布局

### 首页（NewsPage / HomePage）
- **顶部**: 自定义 Header（"开发者资讯" 标题 + 搜索按钮）
- **中部**: 圆角 TabBar（新闻 / 博客），选中标签填色
- **下部**: 双列 MasonryGridView 瀑布流

### 新闻/博客列表 Tab
- 布局: `MasonryGridView.builder(crossAxisCount: 2, spacing: 12)`
- 加载: 空列表时显示 ShimmerGrid
- 下拉刷新: RefreshIndicator
- 无限滚动: NotificationListener<ScrollNotification>

### 登录页
- 背景: 青蓝到深蓝渐变
- Logo: 居中 100x100
- 品牌文字: "开发者资讯" + "发现最新的技术资讯"
- 按钮: 白色 + 青蓝文字 + 大圆角
- 动画: Logo fade-in + 按钮 slide-up (easeOutBack)

### 个人中心（AccountPage）
- **已登录**: 渐变横幅 + 白色边框头像 + 用户名/邮箱 + 功能卡片列表 + 退出按钮
- **未登录**: 同渐变背景 + Logo + "去登录" 按钮

### 搜索页
- 搜索框: 填充式 + 清除按钮
- 目录: ChoiceChip（新闻/博客/项目）
- 搜索历史: Chip 带删除按钮 + "清除全部"

### 详情页
- 加载中: ShimmerCard 骨架屏
- 错误: `error_outline` 图标 + 文字 + 圆角重试按钮
- 内容: WebView / Markdown 渲染（保留原有实现）

## 颜色硬编码规则

- 优先使用主题色（`Theme.of(context).colorScheme.*`）
- 通用颜色常量集中在 `lib/theme/app_colors.dart`
- 避免在组件中硬编码 `Colors.grey`、`Colors.blue` 等

## 主题文件组织

```
lib/theme/
├── app_colors.dart    # 所有颜色常量
└── app_theme.dart     # 亮色/暗色 ThemeData 工厂
```