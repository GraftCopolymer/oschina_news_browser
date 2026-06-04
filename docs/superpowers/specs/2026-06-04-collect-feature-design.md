# 收藏功能全链路实现设计

> **Goal:** 实现收藏功能的前后端全链路，用户可在文章详情页收藏/取消收藏新闻和博客，并在个人中心查看收藏列表。

**Approach:** 纯代理 OSCHINA API（方案 A），不建立本地收藏数据库表，所有收藏操作实时通过 OSCHINA `favorite_add/favorite_remove/favorite_list` 完成。

**Tech Stack:** FastAPI (Python), Flutter (Dart), Dio, GetX

---

## 设计

### 后端：OSCHINA 代理层

```python
# impl/collect_api.py（新增）
# 三个 async 函数，通过 httpx 调用 OSCHINA 收藏 API

async def oschina_collect_add(access_token: str, obj_id: int, obj_type: int) -> dict
async def oschina_collect_remove(access_token: str, obj_id: int, obj_type: int) -> dict
async def oschina_collect_list(access_token: str, type: int, page: int, page_size: int) -> dict
```

### 后端：路由实现

`impl/default_api_impl.py` 中三个 stub endpoint 替换为真实逻辑：

**`POST /collect/add`**
- 获取当前用户的 OSCHINA token（`get_current_user_oschina_token()`）
- 前端传入 `targetType`（`"news"`/`"blog"`）和 `targetId`
- 后端映射 `news→4`, `blog→3`
- 调用 `oschina_collect_add(token, targetId, mappedType)`
- 返回 `success_response`

**`POST /collect/remove`**
- 同上逻辑，调用 `oschina_collect_remove`

**`GET /collect/list`**
- 获取用户 OSCHINA token
- 调用 `oschina_collect_list(token, type=0, page, pageSize)`
- OSCHINA 返回 `{ "favoriteList": [{ "title": "...", "objid": ..., "type": 4, "url": "..." }] }`
- 前端需要 `type` 字段判断跳转类型（3=博客, 4=新闻），`objid` 用于跳转详情

### 前端：收藏状态检查

详情页加载时，需要知道当前文章是否已被收藏：

**方式：** 在 `collect/list` 返回的列表中查找匹配的 `objid`。但由于分页限制，新增轻量端点 `GET /collect/check?targetType=&targetId=` 更直接——直接调用 OSCHINA `favorite_list` 翻页匹配，或在 `favorite_detail` 端点中检查 `favorite` 字段。

更简单的方式：OSCHINA 的 news_detail 和 blog_detail 接口返回 `favorite` 字段（0=未收藏 1=已收藏），详情页加载时直接由后端返回该字段。但当前后端 `news_detail` 和 `blog_detail` 端点在代理 OSCHINA 时已返回原始数据，OSCHINA 响应中已有 `favorite` 字段。

**确认后采用的方案：** 详情页加载时，如果 `favorite` 字段存在且为 1，则显示已收藏图标。否则显示未收藏。

但当前 `NewsDetail` 和 `BlogDetail` 模型没有 `favorite` 字段。需要：

**方案：** 在 `extra_models.py` 的 `NewsDetail`/`BlogDetail` 模型上添加可选字段 `favorite: Optional[int] = None`（0=未收藏, 1=已收藏），由 OSCHINA 原始数据自动填充。

### 前端：详情页收藏操作

**`detail_bottom_bar.dart` 的收藏按钮：**
- 未收藏时：`Icons.bookmark_border`（空心）
- 已收藏时：`Icons.bookmark`（实心）+ 品牌色 `#0D9488`
- 点击后：立即更新图标（乐观更新），同时异步调 `collectAddPost`/`collectRemovePost`
- 成功后弹 Toast，失败时回滚图标

**数据传递：**
- `NewsDetailPage` / `BlogDetailPage` 将 `_detail` 中的 `favorite` 字段传给 `DetailBottomBar`
- `DetailBottomBar.onBookmark` 回调改为带状态，接收 `isFavorited` 和 `onToggle`

### 前端：收藏列表页

新建 `collect_page.dart`：
- 使用 `MasonryGridView` 瀑布流布局（复用 `StaggeredNewsCard`/`StaggeredBlogCard` 风格但标题渐变颜色算法不同）
- 从 `collect/list` 获取数据
- OSCHINA 返回的每个收藏项格式：`{ title, objid, type, url }`
- `type=3` → 博客，跳转 `BlogDetailPage(objid)`
- `type=4` → 新闻，跳转 `NewsDetailPage(objid)`
- 卡片样式：渐变色卡片（简化版，用标题 hash 生成颜色），显示标题和类型标签
- 支持下拉刷新
- 空状态：显示 "暂无收藏"
- 支持底部滚动加载更多

### 前端：账户页导航

`account_page.dart` 中"我的收藏"按钮跳转到 `CollectListPage`。

---

## 数据流

```
收藏操作:
  前端点击收藏/取消
    → DetailBottomBar.onBookmark()
    → collectAddPost(targetType, targetId) / collectRemovePost(targetType, targetId)
    → GET /collect/add 或 /collect/remove
    → 后端 oschina_collect_add/remove(token, id, type)
    → OSCHINA API
    → 结果返回前端 → Toast 提示

收藏列表:
  账户页点击"我的收藏"
    → CollectListPage
    → collectListGet(page, pageSize)
    → GET /collect/list
    → 后端 oschina_collect_list(token, 0, page, pageSize)
    → OSCHINA API
    → 返回 favoriteList → 瀑布流展示
    → 点击卡片 → NewsDetailPage / BlogDetailPage
```

## 未涵盖的内容（后续迭代）

- 收藏列表页的离线缓存
- 收藏标签筛选（按类型筛选新闻/博客）
- 收藏列表的编辑模式（批量取消收藏）