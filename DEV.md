# OSCHINA IT 资讯 App — 开发路线图

> 本文档记录项目的功能现状、未使用的 OSCHINA API 端点、以及推荐的后续开发方向。目标是帮助开发者明确哪些需求可以开发，哪些功能能让项目在学校作业中脱颖而出。

---

## 一、项目当前功能状态

### ✅ 已实现功能

| 功能 | 前端 | 后端 | 说明 |
|------|------|------|------|
| 新闻列表/详情 | ✅ 完成 | ✅ 完成 | 瀑布流卡片布局，渐变背景 + 自适应文字颜色 |
| 博客列表/详情 | ✅ 完成 | ✅ 完成 | 同新闻布局，"原创"/"转载" 类型标签 |
| OSCHINA OAuth 登录 | ✅ 完成 | ✅ 完成 | WebView 授权 → JWT → 持久化存储 |
| 退出登录 | ✅ 完成 | ✅ 完成 | 清除本地 token |
| 全局搜索 | ✅ 完成 | ✅ 完成 | 搜索历史管理 + 内嵌瀑布流结果展示 |
| 暗色模式切换 | ✅ 完成 | N/A | 系统/浅色/深色三档，本地持久化 |
| 骨架屏加载 | ✅ 完成 | N/A | Shimmer 动画（详情页/列表页两种模式） |
| WebView 图片预览 | ✅ 完成 | N/A | Hero 动画放大查看 |
| 关于页面 | ✅ 完成 | N/A | 精简版关于页，含技术栈卡片和 GitHub 链接 |
| 下拉刷新定制 | ✅ 完成 | N/A | RefreshIndicator 品牌色定制（青蓝主色） |
| 阅读个性化设置 | ✅ 完成 | N/A | 字号/行距/护眼模式，实时 CSS 注入 |
| 阅读进度条 | ✅ 完成 | N/A | WebView 滚动顶部进度指示器 |
| 文章目录 TOC | ✅ 完成 | N/A | 从 h1/h2/h3 自动生成，点击跳转 |
| 底部操作栏 | ✅ 完成 | N/A | 滚动感知滑入/滑出，阅读设置/目录/收藏 |
| 收藏功能 | ⬜ 未实现 | 🟡 存根 | 后端 3 个 endpoint 返回桩响应，前端收藏按钮/页面未实现 |
| 刷新/无限滚动 | ✅ 完成 | N/A | RefreshIndicator + ScrollNotification 底部加载 |

### 🔴 已知问题

| 问题 | 位置 | 严重程度 | 说明 |
|------|------|----------|------|
| `commentCount` 类型转换警告 | `news_check_app/lib/controllers/news_list_controller.dart:52` | 低 | OSCHINA API 将评论数作为字符串返回，模型要求 int |

---

## 二、OSCHINA API 使用情况

### 当前已使用的 OSCHINA 端点（5 个）

| OSCHINA 端点 | 映射路由 | 用途 |
|-------------|---------|------|
| `/action/openapi/news_list` | `GET /news/list` | 新闻列表 |
| `/action/openapi/news_detail` | `GET /news/detail/{id}` | 新闻详情 |
| `/action/openapi/blog_recommend_list` | `GET /blog/list` | 博客推荐列表 |
| `/action/openapi/blog_detail` | `GET /blog/detail/{id}` | 博客详情 |
| `/action/openapi/search_list` | `GET /search` | 全局搜索 |

### 未使用的 OSCHINA 端点（38 个）

#### 🔥 高价值（直接提升 App 功能完整性）

| 端点 | 分类 | 推荐场景 |
|------|------|----------|
| `/action/openapi/favorite_list` | 收藏 | 实现"我的收藏"列表页 |
| `/action/openapi/favorite_add` | 收藏 | 实现收藏/取消收藏按钮 |
| `/action/openapi/favorite_remove` | 收藏 | 同上 |
| `/action/openapi/comment_list` | 评论 | 在详情页底部展示文章评论 |
| `/action/openapi/comment_pub` | 评论 | 用户发表评论 |
| `/action/openapi/blog_comment_list` | 评论 | 博客详情页展示评论 |
| `/action/openapi/blog_comment_pub` | 评论 | 用户发表博客评论 |
| `/action/openapi/user_information` | 个人 | 在个人中心展示更丰富的用户信息 |

#### ⭐ 中等价值（扩展 App 内容广度）

| 端点 | 分类 | 推荐场景 |
|------|------|----------|
| `/action/openapi/active_list` | 动态 | 首页增加"最新动态" Tab（含 tweetImage 封面图字段） |
| `/action/openapi/tweet_list` | 动弹 | 类似微博的时间线信息流 |
| `/action/openapi/tweet_detail` | 动弹 | 动弹详情页 |
| `/action/openapi/tweet_pub` | 动弹 | 发布动弹（OSCHINA 类微博） |
| `/action/openapi/project_list` | 软件项目 | 第四个 Tab：开源项目推荐 |
| `/action/openapi/project_detail` | 软件项目 | 项目详情页 |
| `/action/openapi/project_catalog_list` | 软件项目 | 项目分类浏览 |
| `/action/openapi/project_tag_list` | 软件项目 | 项目标签筛选 |
| `/action/openapi/post_list` | 帖子 | 论坛帖子列表 |
| `/action/openapi/post_detail` | 帖子 | 帖子详情页 |
| `/action/openapi/blog_list` | 博客 | 全部博客（非推荐排序） |
| `/action/openapi/blog_catalog_list` | 博客 | 博客分类浏览 |

#### 📬 增值功能（社交/消息）

| 端点 | 分类 | 推荐场景 |
|------|------|----------|
| `/action/openapi/user_notice` | 通知 | 通知列表页面 |
| `/action/openapi/clear_notice` | 通知 | 清空通知 |
| `/action/openapi/message_list` | 私信 | 私信列表 |
| `/action/openapi/friends_list` | 社交 | 关注/粉丝列表 |
| `/action/openapi/update_user_relation` | 社交 | 关注/取消关注 |
| `/action/openapi/my_information` | 个人 | 编辑个人资料 |
| `/action/openapi/portrait_update` | 个人 | 修改头像 |

---

## 三、推荐开发需求（按优先级）

### P0 — 完善现有功能缺口

#### 1. 搜索功能完善
- **现状**: `SearchPage` 只保存搜索历史到本地存储，按回车后**从未调用搜索 API**，也未显示搜索结果
- **工作量**: ~2 天
- **前后端**: 仅前端修改，后端搜索 API 已完全实现
- **涉及文件**:
  - `news_check_app/lib/pages/search_page.dart`
  - `news_check_app/lib/controllers/`（可能需要新建 `search_controller.dart`）
  - `news_check_app/lib/services/api_client.dart`（已有 `searchGet()` 方法，无需修改）
- **设计参考**: 搜索结果页面复用 `news_tab.dart` / `blog_tab.dart` 的瀑布流布局

#### 2. 收藏系统全链路实现
- **现状**: 后端三个收藏 endpoint 返回桩响应，前端账户页"我的收藏"按钮回调为空，新闻/博客详情页无收藏按钮
- **工作量**: ~3 天（后端 1 天 + 前端 2 天）
- **后端改动**:
  - 新增 `DBCollect` 数据库表（`target_type`, `target_id`, `user_id`, `created_at`）
  - 实现 `collect/add`、`collect/remove`、`collect/list` 三个 endpoint 的真实逻辑
  - `collect/list` 返回后，后端根据收藏 ID 批量请求 OSCHINA 获取最新标题/摘要
- **前端改动**:
  - 详情页底部添加收藏/取消收藏按钮（带图标动画）
  - "我的收藏"页面（复用瀑布流布局展示收藏的新闻/博客）
  - 账户页"我的收藏"按钮跳转到收藏列表页

---

### P1 — 新功能（提升内容丰富度）

#### 3. 评论浏览功能
- **说明**: 在新闻/博客详情页底部展示 OSCHINA 评论
- **收益**: 极大提升详情页的丰富度，展示用户互动氛围
- **工作量**: ~2 天
- **API**: `/action/openapi/comment_list`, `/action/openapi/blog_comment_list`

#### 4. 软件项目浏览（第四个 Tab）
- **说明**: 在底部导航栏新增"项目" Tab，展示 OSCHINA 开源项目
- **收益**: 扩展 App 内容类型，从"资讯"变为"开发者平台"
- **工作量**: ~3 天
- **API**: `/action/openapi/project_list`, `/action/openapi/project_detail`, `/action/openapi/project_catalog_list`

#### 5. "最新动态" Tab
- **说明**: 使用 `active_list` 接口获取用户动态信息流，**该接口返回含有图片的推文数据**（`tweetImage`），可与现有纯文字卡片形成视觉差异
- **收益**: 为 App 增加带封面图的卡片类型，丰富 UI 多样性
- **工作量**: ~2 天
- **API**: `/action/openapi/active_list`

---

### P2 — 差异化功能（让项目出彩）

以下功能是**拉开与其他同学项目差距**的关键方向。

#### 6. 离线阅读缓存
- **说明**: 将已查看的新闻/博客详情缓存到本地（SQLite 或文件），无网络可阅读
- **收益**: 大部分同学不会做离线支持，这是**明显的加分项**
- **工作量**: ~2 天
- **实现思路**:
  - 使用 `sqflite` 或 `hive` 本地数据库
  - 详情页加载成功后自动缓存
  - 列表页显示"已离线"标记
  - 设置页添加"清除缓存"按钮 + 缓存大小显示

#### 7. 阅读历史与数据统计
- **说明**: 记录用户阅读记录，展示阅读统计（今日阅读数、累计阅读数、阅读偏好等）
- **收益**: 展示数据分析能力，有可视化元素（柱状图/饼图）
- **工作量**: ~3 天
- **实现思路**:
  - 本地数据库记录每次阅读（文章 ID、类型、时间）
  - 数据统计页面：阅读趋势折线图、类型分布饼图、阅读时长统计
  - 可用 `fl_chart` 或 `syncfusion_flutter_charts` 图表库

#### 8. 热词 / 热门话题标签
- **说明**: 从新闻列表的标题中提取高频关键词，生成话题标签云
- **收益**: 体现算法/Clever 设计思维，视觉上非常出彩
- **工作量**: ~2 天
- **实现思路**:
  - 首页顶部显示 TagCloud / Wrap 排列的热门话题标签
  - 点击标签跳转到对应关键词的搜索结果
  - 关键词可以简单从标题分词提取，无需 NLP

#### 9. 资讯分享（生成精美分享卡片）
- **说明**: 阅读文章时可分享到其他 App，生成包含标题、摘要、渐变背景的精美图片卡片
- **收益**: 功能完整度高，有社交传播属性，**演示时很酷**
- **工作量**: ~3 天
- **实现思路**:
  - 使用 `share_plus` 分享文本链接
  - 使用 `screenshot` 或 `RepaintBoundary` 生成截图卡片
  - 卡片复用瀑布流卡片的渐变风格，保持一致的设计语言

#### 10. 字体大小 / 阅读偏好设置
- **说明**: 在阅读详情页可调整字体大小、行间距、背景色（护眼模式）
- **收益**: 体现用户体验设计的深入思考，展示 Flutter 状态管理能力
- **工作量**: ~1.5 天
- **实现思路**:
  - 详情页底部弹出 BottomSheet 调整字体大小滑杆
  - 设置页增加阅读偏好选项
  - 使用 Provider/GetX 全局管理阅读设置

---

## 四、如何让项目出彩（面试级功能）

> 以下功能不依赖 OSCHINA API，纯前端能力展示。**与只实现列表+详情的普通同学拉开差距。**

### ⭐ S 级 — 面试亮点

| 功能 | 难度 | 工作量 | 为什么出彩 |
|------|------|--------|-----------|
| **离线缓存 + 阅读统计** | 中 | 3天 | 95% 的同学不会做离线缓存，结合数据统计展示"产品思维" |
| **Skeleton 骨架屏 + 微动效** | 中 | 2天 | 已实现，但可进一步细化（列表项出现动画、页面转场） |
| **分享精美卡片** | 中 | 3天 | 演示时可现场分享，展示"完整产品"意识 |
| **Widget 测试覆盖率** | 低 | 1天 | 大部分同学不写测试，**直接拉开差距** |

### ⭐ A 级 — 优秀加分

| 功能 | 难度 | 工作量 | 说明 |
|------|------|--------|------|
| 热词标签云 | 低 | 1天 | 体现数据洞察力 |
| 护眼阅读模式 | ✅ 已实现 | — | 字号/行距/背景色实时调整 |
| 多语言(i18n) | 低 | 1天 | 展示国际化能力 |
| 关于页面 | ✅ 已实现 | — | 精简版，含技术栈卡片和 GitHub 链接 |
| 品牌色下拉刷新 | ✅ 已实现 | — | RefreshIndicator 青蓝主色定制 |
| 搜索功能（API 结果展示） | ✅ 已实现 | — | 内嵌瀑布流搜索结果展示 |
| 搜索历史管理 | ✅ 已实现 | — | 搜索记录管理已完成 |

### ⭐ B 级 — 基础加分

| 功能 | 难度 | 工作量 | 说明 |
|------|------|--------|------|
| 点击作者跳转 | 中 | 1天 | 搜索该作者所有文章 |
| 多语言(i18n) | 低 | 1天 | 展示国际化能力 |

---

## 五、推荐开发顺序

对初学者或时间有限的开发者，按以下顺序开发：

```
第一周（基础完善）:
  1. ✅ 搜索功能完善（P0）— ✅ 已完成
  2. ✅ 关于页面（B级）— ✅ 已完成
  3. ✅ 下拉刷新定制（B级）— ✅ 已完成
  4. □ 收藏系统全链路（P0）— 2-3天

第二周（内容丰富）:
  5. □ 评论浏览（P1）— 1-2天
  6. □ 软件项目 Tab（P1）— 2-3天

第三周（差异化）:
  7. □ 离线阅读缓存（P2）— 2天
  8. □ 阅读统计（P2）— 1-2天
  9. □ 热词标签云（P2）— 1天

第四周（打磨）:
  10. □ 分享卡片（P2）— 2天
  11. ✅ 阅读偏好设置（P2）— 1天
  12. □ 动画微调 + 测试（S级）— 2天
```

---

## 六、技术债务

| 项目 | 说明 | 建议 |
|------|------|------|
| `commentCount` 类型 | API 返回字符串，模型要求 int | 在 `api_client.dart` 或控制器中做 `int.parse` 转换 |
| 收藏数据库表 | 缺少 `DBCollect` 模型 | 实现收藏功能时必须添加 |
| 搜索 API 的 catalog 映射 | 前端用"新闻/博客/项目"，但 OSCHINA 搜索参数可能不同 | 实现搜索 API 调用前需要确认 catalog 值映射 |
| API 错误处理 | 某些错误场景下用户只看到空白页面 | 建议全局添加 Toast/SnackBar 错误提示 |
| 页面之间状态同步 | 如收藏后返回列表页，列表页不知道收藏状态已变化 | 考虑使用 GetX 的事件总线或回调刷新 |

---

> **注**: 本文档会随着项目迭代持续更新。建议每完成一个功能后在此处打勾标记。