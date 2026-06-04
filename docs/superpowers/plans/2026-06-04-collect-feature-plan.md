# 收藏功能全链路实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 实现收藏功能前后端全链路：详情页可收藏/取消收藏新闻和博客，个人中心可查看收藏列表。

**Architecture:** 纯代理 OSCHINA API（无本地收藏表）。后端三个端点直接调用 OSCHINA `favorite_add/remove/list`，前端通过 GetX + Dio 操作。类型映射 `news→4, blog→3`。

**Tech Stack:** FastAPI (httpx), Flutter (Dio, GetX, freezed)

---

## 文件结构

| 文件 | 操作 | 职责 |
|------|------|------|
| `backend/src/openapi_server/models/extra_models.py` | 修改 | NewsDetail/BlogDetail 添加 `favorite` 字段 |
| `backend/src/openapi_server/impl/utils.py` | 修改 | 新增 3 个 OSCHINA 收藏 API 辅助函数 |
| `backend/src/openapi_server/impl/default_api_impl.py` | 修改 | 实现 3 个收集 endpoint 真实逻辑 |
| `backend/tests/test_collect.py` | 新建 | 后端收藏功能单元测试 |
| `news_check_app/lib/models/models.dart` | 修改 | NewsDetail/BlogDetail 添加 `favorite` 字段 |
| `news_check_app/lib/widgets/detail_bottom_bar.dart` | 修改 | 收藏按钮支持图标切换 |
| `news_check_app/lib/pages/news_detail_page.dart` | 修改 | 实现收藏/取消收藏逻辑 |
| `news_check_app/lib/pages/blog_detail_page.dart` | 修改 | 同新闻详情页 |
| `news_check_app/lib/pages/collect_page.dart` | 新建 | 收藏列表页（瀑布流） |
| `news_check_app/lib/pages/account_page.dart` | 修改 | 导航到收藏列表页 |
| `news_check_app/test/collect_page_test.dart` | 新建 | 收藏功能前端测试 |

---

## Tasks

### Task 1: Backend — 给 NewsDetail/BlogDetail 加 `favorite` 字段

**Files:**
- Modify: `backend/src/openapi_server/models/extra_models.py:40-47`, `:57-63`

- [ ] **修改 NewsDetail**，添加 `favorite` 可选字段

```python
class NewsDetail(BaseModel):
    id: int
    body: str
    pubDate: str
    author: str
    title: str
    authorid: int
    favorite: Optional[int] = None  # 0-未收藏 1-已收藏，由 OSCHINA 原始数据填充
```

- [ ] **修改 BlogDetail**，同样添加

```python
class BlogDetail(BaseModel):
    id: int
    body: str
    pubDate: str
    author: str
    title: str
    authorid: int
    favorite: Optional[int] = None
```

- [ ] **运行现有测试确认无回归**

Run: `PYTHONPATH=src python -m pytest tests/ -v`
Expected: 12 passed

- [ ] **Commit**

```bash
git add backend/src/openapi_server/models/extra_models.py
git commit -m "feat: add favorite field to NewsDetail/BlogDetail models"
```

---

### Task 2: Backend — 新增 OSCHINA 收藏 API 辅助函数

**Files:**
- Modify: `backend/src/openapi_server/impl/utils.py`

在 `utils.py` 末尾添加三个函数。注意 OSCHINA 收藏 API 使用 `POST` 和表单数据。

- [ ] **添加 `oschina_collect_add`**

```python
async def oschina_collect_add(access_token: str, obj_id: int, obj_type: int) -> dict:
    """调用 OSCHINA 添加收藏"""
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            oschina("/action/openapi/favorite_add"),
            data={
                "access_token": access_token,
                "id": obj_id,
                "type": obj_type,
                "dataType": "json",
            },
            headers=headers,
        )
        if resp.status_code != 200:
            raise HTTPException(status_code=500, detail="OSCHINA 收藏失败")
        return resp.json()
```

- [ ] **添加 `oschina_collect_remove`**

```python
async def oschina_collect_remove(access_token: str, obj_id: int, obj_type: int) -> dict:
    """调用 OSCHINA 取消收藏"""
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            oschina("/action/openapi/favorite_remove"),
            data={
                "access_token": access_token,
                "id": obj_id,
                "type": obj_type,
                "dataType": "json",
            },
            headers=headers,
        )
        if resp.status_code != 200:
            raise HTTPException(status_code=500, detail="OSCHINA 取消收藏失败")
        return resp.json()
```

- [ ] **添加 `oschina_collect_list`**

```python
async def oschina_collect_list(
    access_token: str, type: int = 0, page: int = 1, page_size: int = 20
) -> dict:
    """调用 OSCHINA 获取收藏列表"""
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            oschina("/action/openapi/favorite_list"),
            data={
                "access_token": access_token,
                "type": type,
                "page": page,
                "pageSize": page_size,
                "dataType": "json",
            },
            headers=headers,
        )
        if resp.status_code != 200:
            raise HTTPException(status_code=500, detail="OSCHINA 获取收藏列表失败")
        return resp.json()
```

- [ ] **运行现有测试确认无回归**

Run: `PYTHONPATH=src python -m pytest tests/ -v`
Expected: 12 passed

- [ ] **Commit**

```bash
git add backend/src/openapi_server/impl/utils.py
git commit -m "feat: add oschina_collect_add/remove/list helper functions"
```

---

### Task 3: Backend — 实现收集 endpoint 真实逻辑

**Files:**
- Modify: `backend/src/openapi_server/impl/default_api_impl.py:359-416`

- [ ] **实现 `POST /collect/add`**

```python
@router.post(
    "/collect/add",
    responses={
        200: {"model": ApiResponse, "description": "请求成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["收藏管理"],
    summary="添加收藏（新闻/博客）",
    response_model_by_alias=True,
)
async def collect_add_post(
    user: UserDep,
    collect_request: CollectRequest = Body(None, description=""),
) -> ApiResponse:
    """保存收藏类型+ID，后端关联用户"""
    type_map = {"news": 4, "blog": 3}
    oschina_type = type_map.get(collect_request.target_type)
    if oschina_type is None:
        raise HTTPException(status_code=400, detail="不支持的收藏类型")
    try:
        result = await oschina_collect_add(
            user.oschina_token, collect_request.target_id, oschina_type
        )
        return success_response(data=result, msg="收藏成功")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"收藏失败: {e}")
```

- [ ] **实现 `POST /collect/remove`**

```python
@router.post(
    "/collect/remove",
    responses={
        200: {"model": ApiResponse, "description": "请求成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["收藏管理"],
    summary="取消收藏",
    response_model_by_alias=True,
)
async def collect_remove_post(
    user: UserDep,
    collect_request: CollectRequest = Body(None, description=""),
) -> ApiResponse:
    type_map = {"news": 4, "blog": 3}
    oschina_type = type_map.get(collect_request.target_type)
    if oschina_type is None:
        raise HTTPException(status_code=400, detail="不支持的收藏类型")
    try:
        result = await oschina_collect_remove(
            user.oschina_token, collect_request.target_id, oschina_type
        )
        return success_response(data=result, msg="已取消收藏")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"取消收藏失败: {e}")
```

- [ ] **实现 `GET /collect/list`**

```python
@router.get(
    "/collect/list",
    responses={
        200: {"model": ApiResponse, "description": "获取成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["收藏管理"],
    summary="获取我的收藏列表",
    response_model_by_alias=True,
)
async def collect_list_get(
    user: UserDep,
    page: Optional[StrictInt] = Query(1, description="", alias="page"),
    page_size: Optional[StrictInt] = Query(20, description="", alias="pageSize"),
) -> ApiResponse:
    try:
        result = await oschina_collect_list(
            user.oschina_token, type=0, page=page, page_size=page_size
        )
        return success_response(data=result, msg="获取成功")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取收藏列表失败: {e}")
```

注意：需要在 `default_api_impl.py` 顶部导入新增的函数。

- [ ] **更新 import**

```python
from openapi_server.impl.utils import (
    success_response, oschina_code2token, error_response, create_app_jwt,
    fetch_user_info, oschina, headers,
    oschina_collect_add, oschina_collect_remove, oschina_collect_list,
)
```

- [ ] **运行现有测试确认无回归**

Run: `PYTHONPATH=src python -m pytest tests/ -v`
Expected: 12 passed

- [ ] **Commit**

```bash
git add backend/src/openapi_server/impl/default_api_impl.py
git commit -m "feat: implement collect/add, collect/remove, collect/list endpoints"
```

---

### Task 4: Backend — 写收集功能的测试

**Files:**
- Create: `backend/tests/test_collect.py`

- [ ] **创建测试文件，测试类型映射和函数签名**

```python
"""Tests for collect feature."""

import pytest
from pydantic import ValidationError

from openapi_server.models.collect_request import CollectRequest
from openapi_server.impl.utils import (
    success_response,
    error_response,
)


class TestCollectRequest:
    def test_valid_news(self):
        req = CollectRequest(targetType="news", targetId=123)
        assert req.target_type == "news"
        assert req.target_id == 123

    def test_valid_blog(self):
        req = CollectRequest(targetType="blog", targetId=456)
        assert req.target_type == "blog"

    def test_invalid_type(self):
        with pytest.raises(ValidationError):
            CollectRequest(targetType="project", targetId=1)
```

- [ ] **运行测试确认通过**

Run: `PYTHONPATH=src python -m pytest tests/ -v`
Expected: 15 passed (12 original + 3 new)

- [ ] **Commit**

```bash
git add backend/tests/test_collect.py
git commit -m "test: add collect feature backend tests"
```

---

### Task 5: Frontend — 给 NewsDetail/BlogDetail 加 `favorite` 字段

**Files:**
- Modify: `news_check_app/lib/models/models.dart`

- [ ] **修改 NewsDetail 添加 `favorite`**

```dart
@freezed
abstract class NewsDetail with _$NewsDetail {
  const factory NewsDetail({
    required int id,
    required String body,
    required String pubDate,
    required String author,
    required String title,
    required int authorid,
    int? favorite,
  }) = _NewsDetail;
```

- [ ] **修改 BlogDetail 添加 `favorite`**

```dart
@freezed
abstract class BlogDetail with _$BlogDetail {
  const factory BlogDetail({
    required int id,
    required String body,
    required String pubDate,
    required String author,
    required String title,
    required int authorid,
    int? favorite,
  }) = _BlogDetail;
```

- [ ] **重新生成 freezed 和 json_serializable 代码**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors

- [ ] **运行 `flutter analyze` 确认无问题**

Run: `flutter analyze`
Expected: no errors/warnings

- [ ] **Commit**

```bash
git add news_check_app/lib/models/
git commit -m "feat: add favorite field to NewsDetail/BlogDetail models"
```

---

### Task 6: Frontend — 更新 DetailBottomBar 支持收藏状态

**Files:**
- Modify: `news_check_app/lib/widgets/detail_bottom_bar.dart`

- [ ] **修改 DetailBottomBar，添加 `isFavorited` 参数**

```dart
class DetailBottomBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onFontSettings;
  final VoidCallback onToc;
  final VoidCallback onBookmark;
  final bool isFavorited; // 新增

  const DetailBottomBar({
    super.key,
    required this.isVisible,
    required this.onFontSettings,
    required this.onToc,
    required this.onBookmark,
    this.isFavorited = false, // 新增，默认未收藏
  });
```

- [ ] **修改收藏按钮的图标和颜色**

```dart
_BarButton(
  icon: widget.isFavorited ? Icons.bookmark : Icons.bookmark_border,
  label: '收藏',
  color: widget.isFavorited ? const Color(0xFF0D9488) : null,
  onTap: onBookmark,
),
```

注意：`_BarButton` 当前没有 `color` 参数。需要给 `_BarButton` 添加一个可选的 `color` 参数，当存在时覆盖默认前景色。

- [ ] **给 _BarButton 添加 color 参数**

```dart
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
```

在 `build` 方法中：
```dart
final foreground = disabled
    ? (color ?? colorScheme.onSurface.withAlpha(80))
    : (color ?? colorScheme.onSurface);
```

- [ ] **运行 `flutter analyze` 确认无问题**

- [ ] **Commit**

```bash
git add news_check_app/lib/widgets/detail_bottom_bar.dart
git commit -m "feat: update DetailBottomBar with favorite toggle icons"
```

---

### Task 7: Frontend — 在详情页实现收藏/取消收藏

**Files:**
- Modify: `news_check_app/lib/pages/news_detail_page.dart`
- Modify: `news_check_app/lib/pages/blog_detail_page.dart`

- [ ] **NewsDetailPage: 添加 `_isFavorited` 状态并在初始化时从 detail 加载**

```dart
bool _isFavorited = false;

// 在 _initData 的缓存加载和 API 加载中设置：
_isFavorited = detail.favorite == 1; // 加载缓存的 detail
// 和
_isFavorited = newsDetail.favorite == 1; // 加载 API 返回的 detail
```

- [ ] **NewsDetailPage: 修改 DetailBottomBar 传参**

```dart
DetailBottomBar(
  isVisible: _showBottomBar,
  isFavorited: _isFavorited,
  onFontSettings: () => showReadingSettingsSheet(context),
  onToc: _showToc,
  onBookmark: () => _toggleFavorite(),
),
```

- [ ] **NewsDetailPage: 添加 `_toggleFavorite()` 方法**

```dart
Future<void> _toggleFavorite() async {
  // 乐观更新
  final newState = !_isFavorited;
  setState(() => _isFavorited = newState);

  try {
    if (newState) {
      await api.collectAddPost(collectRequest: {
        "targetType": "news",
        "targetId": widget.newsId,
      });
      Fluttertoast.showToast(msg: "已收藏");
    } else {
      await api.collectRemovePost(collectRequest: {
        "targetType": "news",
        "targetId": widget.newsId,
      });
      Fluttertoast.showToast(msg: "已取消收藏");
    }
  } catch (e) {
    // 失败回滚
    setState(() => _isFavorited = !newState);
    Fluttertoast.showToast(msg: "操作失败，请重试");
  }
}
```

- [ ] **BlogDetailPage: 同样的修改**
  - 添加 `_isFavorited` 状态
  - 添加 `_toggleFavorite()`（`targetType` 为 `"blog"`）
  - 传递给 DetailBottomBar

- [ ] **运行 `flutter analyze` 确认无问题**

- [ ] **Commit**

```bash
git add news_check_app/lib/pages/news_detail_page.dart
git add news_check_app/lib/pages/blog_detail_page.dart
git commit -m "feat: implement collect/uncollect in detail pages"
```

---

### Task 8: Frontend — 创建收藏列表页

**Files:**
- Create: `news_check_app/lib/pages/collect_page.dart`

- [ ] **创建 CollectListPage**
  - 使用 `MasonryGridView` 瀑布流布局
  - 调用 `api.collectListGet()` 获取数据
  - OSCHINA 返回 `favoriteList` 数组，每项结构：`{title, objid, type, url}`
  - 类型映射：`type=3 → blog`, `type=4 → news`
  - 卡片使用 AppColors.gradientFromTitle 生成渐变色
  - 显示标题和类型标签
  - 点击卡片 → `NewsDetailPage(objid)` 或 `BlogDetailPage(objid)`
  - 空状态：图标 + "暂无收藏"
  - 下拉刷新

```dart
class CollectPage extends StatefulWidget {
  const CollectPage({super.key});

  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  bool _hasMore = true;
  int _page = 1;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
    }
    setState(() => _loading = _page == 1);

    try {
      final resp = await api.collectListGet(page: _page, pageSize: _pageSize);
      final body = resp.data as Map<String, dynamic>?;
      final data = body?['data'] as Map<String, dynamic>?;
      final list = data?['favoriteList'] as List<dynamic>? ?? [];

      if (refresh || _page == 1) {
        _items = list.cast<Map<String, dynamic>>();
      } else {
        _items.addAll(list.cast<Map<String, dynamic>>());
      }

      _hasMore = list.length >= _pageSize;
      if (_hasMore) _page++;
    } catch (e) {
      if (_items.isEmpty) {
        // show error
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  // ... build method with MasonryGridView
}
```

- [ ] **运行 `flutter analyze` 确认无问题**

- [ ] **Commit**

```bash
git add news_check_app/lib/pages/collect_page.dart
git commit -m "feat: create CollectListPage with waterfall layout"
```

---

### Task 9: Frontend — 账户页导航

**Files:**
- Modify: `news_check_app/lib/pages/account_page.dart:177`

- [ ] **修改"我的收藏"按钮**

```dart
_listTile(Icons.star_border, "我的收藏", () {
  Get.to(() => const CollectPage());
}),
```

- [ ] **运行 `flutter analyze` 确认无问题**

- [ ] **Commit**

```bash
git add news_check_app/lib/pages/account_page.dart
git commit -m "feat: wire up collect page navigation in account page"
```

---

### Task 10: 最终验证

- [ ] **运行后端所有测试**

Run: `PYTHONPATH=src python -m pytest tests/ -v`
Expected: all tests pass

- [ ] **运行前端 `flutter analyze`**

Run: `flutter analyze`
Expected: no errors/warnings

- [ ] **运行前端测试**

Run: `flutter test`
Expected: all tests pass

- [ ] **最终的 git commit（如果还有未提交的清理）**