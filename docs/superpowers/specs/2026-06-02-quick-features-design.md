# 三个快速功能实现方案

> 关于页面、搜索结果展示、下拉刷新动画定制

## 1. 关于页面

**目标**: 精简版关于页，展示 App 名称、版本号、简介、GitHub 链接。

**文件**:
- 新建: `news_check_app/lib/pages/about_page.dart`
- 修改: `news_check_app/lib/pages/account_page.dart`

**布局**:
- `Scaffold` + `AppBar(title: "关于")`
- `SingleChildScrollView` + `Column` 居中布局
- App 名称 "开发者资讯"（headlineMedium，加粗）
- 版本号 "v1.0.0"（从 `pubspec.yaml` 读取，bodyMedium，次要色）
- 简介段落（描述 App 功能）
- GitHub 链接按钮（图标 + 文字，点击用 `url_launcher` 打开；或用 `Clipboard` 复制链接）

**与账户页集成**:
- 账户页 "关于" `ListTile` 的 `onTap` 改为 `Get.to(() => const AboutPage())`

**主题**:
- 自动适配亮色/暗色模式
- 卡片式分组，与设置页风格一致

## 2. 搜索结果内嵌展示

**目标**: 搜索页输入关键词后，历史记录区域被替换为瀑布流搜索结果。

**文件**:
- 新建: `news_check_app/lib/controllers/search_controller.dart`
- 修改: `news_check_app/lib/pages/search_page.dart`

**控制器** (`ResultSearchController`):
- `RxList<NewsSimple> searchResults` — 搜索结果
- `RxBool isSearching` — 搜索中状态
- `search(String query, String catalog)` — 调用 `api.searchGet()`
  - catalog 值映射: "新闻" → `news`, "博客" → `blog`
  - 设置 `isSearching = true`
  - 调用 API 获取结果
  - 解析为 `NewsSimple`（新闻）或 `BlogSimple`（博客）
  - 设置 `isSearching = false`

**交互流程**:
1. 进入页面 → 显示搜索历史
2. 按回车搜索 → 隐藏历史记录区域，显示搜索结果
3. 搜索结果使用 `MasonryGridView` 双列瀑布流
   - 搜索"新闻" → `StaggeredNewsCard`
   - 搜索"博客" → `StaggeredBlogCard`
4. 搜索框旁出现 "✕" 返回按钮 → 点击清除搜索结果，回到历史记录视图
5. 切换目录（新闻/博客）时自动重新搜索
6. 点击搜索结果卡片 → 跳转到对应详情页

**与现有 SearchHistoryController 的关系**:
- 两个控制器共存，`SearchHistoryController` 仍管理历史记录
- `ResultSearchController` 只管理搜索请求和结果
- 搜索时先调用 `SearchHistoryController.addHistory()` 再调用 `ResultSearchController.search()`

**复用现有组件**:
- `StaggeredNewsCard` — 新闻搜索结果卡片
- `StaggeredBlogCard` — 博客搜索结果卡片
- 卡片高度规则与列表页一致（200/250/280 三档按标题长度）
- 点击 `onTap` 跳转详情页

## 3. 下拉刷新动画定制

**目标**: 定制新闻/博客列表的 RefreshIndicator，使用 Logo 图标缩放+旋转动画。

**文件**:
- 新建: `news_check_app/lib/widgets/custom_refresh_indicator.dart`
- 修改: `news_check_app/lib/pages/news_tab.dart`
- 修改: `news_check_app/lib/pages/blog_tab.dart`

**实现方案**:
- 基于 `RefreshIndicator` 的 `refresh` 属性，使用 `SliverRefreshControl` 的自定义布局方式
- 具体实现: 创建一个 `CustomRefreshIndicator` 组件，继承或包装 `RefreshIndicator`
- 下拉过程中显示 Logo 图标 + 旋转动画 + "下拉刷新" / "释放刷新" 文字
- 刷新中显示 Logo 持续旋转 + "正在刷新…" 文字
- 颜色使用青蓝主色调

**动画细节**:
- 下拉阶段: Logo 图标从 0° 旋转到 180°（跟随下拉距离）
- 触发阶段: Logo 持续旋转（循环动画）
- 图标使用 `Icons.refresh`（系统图标）或 `Icons.autorenew`
- 动画时长: 300ms 旋转一周

**替换方式**:
- `news_tab.dart` 和 `blog_tab.dart` 中的 `RefreshIndicator` 替换为 `CustomRefreshIndicator`
- 接口保持兼容: `child` + `onRefresh` 参数不变