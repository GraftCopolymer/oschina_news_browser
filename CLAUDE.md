# OSCHINA IT 资讯 APP

Flutter 前端 + FastAPI 后端项目，代理 OSCHINA OpenAPI，提供新闻/博客浏览、搜索、收藏等功能。

## 目录结构

```
├── backend/                          # Python FastAPI 后端
│   ├── src/openapi_server/
│   │   ├── main.py                   # FastAPI 应用入口
│   │   ├── security_api.py           # JWT Bearer 认证
│   │   ├── context.py                # ContextVar（当前 Token / User）
│   │   ├── config/config.py          # pydantic-settings 配置（从 .env 读取）
│   │   ├── database/
│   │   │   ├── database.py           # SQLAlchemy engine + session
│   │   │   ├── models.py             # DBUser 模型（用户表）
│   │   │   └── redis.py              # Redis 客户端
│   │   ├── impl/
│   │   │   ├── default_api_impl.py   # 所有 API 路由定义 + 业务逻辑
│   │   │   └── utils.py              # JWT 创建、OSCHINA 请求、响应封装
│   │   └── models/
│   │       ├── api_response.py       # 全局统一响应格式
│   │       ├── auth_token.py         # 登录返回 Token 模型
│   │       ├── collect_request.py    # 收藏请求模型
│   │       └── extra_models.py       # NewsSimple/BlogSimple/NewsDetail/BlogDetail/TokenModel/User
│   ├── requirements.txt
│   ├── .env                          # 敏感配置（不上传仓库）
│   ├── docker-compose.yaml
│   └── Dockerfile
│
├── news_check_app/                   # Flutter 前端
│   ├── lib/
│   │   ├── main.dart                 # 入口 + AppFrame 框架
│   │   ├── services/api_client.dart  # 自定义 Dio 封装（替代 OpenAPI 生成代码）
│   │   ├── controllers/              # GetX 控制器
│   │   │   ├── auth_controller.dart          # 认证逻辑
│   │   │   ├── news_list_controller.dart     # 新闻列表
│   │   │   ├── blog_list_controller.dart     # 博客列表
│   │   │   ├── app_settings_controller.dart  # 主题/设置
│   │   │   └── search_history_controller.dart# 搜索历史
│   │   ├── models/models.dart        # Freezed 数据模型
│   │   ├── pages/                    # 页面组件
│   │   │   ├── home_page.dart        # Tab 主页面（新闻/博客/最新）
│   │   │   ├── news_tab.dart         # 新闻列表 Tab
│   │   │   ├── blog_tab.dart         # 博客列表 Tab
│   │   │   ├── news_detail_page.dart # 新闻详情
│   │   │   ├── blog_detail_page.dart # 博客详情
│   │   │   ├── common_detail_webview.dart  # WebView 通用详情
│   │   │   ├── common_detail_markdown.dart # Markdown 通用详情
│   │   │   ├── login_page.dart       # 登录页
│   │   │   ├── oschina_login_page.dart     # OSCHINA OAuth WebView 页
│   │   │   ├── search_page.dart      # 搜索页
│   │   │   ├── settings_page.dart    # 设置页
│   │   │   └── account_page.dart     # 个人中心页
│   │   ├── network/token_interceptor.dart  # Dio 401 拦截器
│   │   ├── mixins/                   # 混入组件
│   │   ├── widgets/                  # 可复用组件
│   │   └── utils/                    # 工具函数
│   └── pubspec.yaml
│
└── .gitignore                        # 根 gitignore（Python 模板，含误伤的 lib/ 规则）
```

## 启动命令

### 后端

```bash
cd backend
pip install -r requirements.txt
PYTHONPATH=src uvicorn openapi_server.main:app --reload --port 8000
```

API 文档：`http://localhost:8000/docs`

### 前端

```bash
cd news_check_app
flutter pub get
flutter run
```

## API 路由一览

| 方法 | 路径 | 说明 | 需认证 |
|------|------|------|--------|
| GET | `/auth/oschina/authorize-url` | 获取 OSCHINA 授权链接 | - |
| GET | `/auth/oschina/callback?code=` | OAuth 回调换 JWT | - |
| POST | `/auth/logout` | 退出登录 | ✅ |
| GET | `/news/list?catalog=&page=&pageSize=` | 新闻列表 | ✅ |
| GET | `/news/detail/{id}` | 新闻详情 | ✅ |
| GET | `/blog/list?page=&pageSize=` | 博客列表 | ✅ |
| GET | `/blog/detail/{id}` | 博客详情 | ✅ |
| GET | `/search?q=&catalog=&page=&pageSize=` | 全局搜索 | ✅ |
| POST | `/collect/add` | 添加收藏 | ✅ |
| POST | `/collect/remove` | 取消收藏 | ✅ |
| GET | `/collect/list?page=&pageSize=` | 收藏列表 | ✅ |

所有 API 返回格式统一为 `ApiResponse { code, msg, data }`：
- 成功时 `code=200`，具体数据在 `data` 字段内
- 认证过期时 `code=401`

## 认证流程

1. 前端 GET 后端 `/auth/oschina/authorize-url` 获取 OSCHINA 授权链接
2. WebView 打开该链接，用户授权后 OSCHINA 302 重定向带回 `code`
3. 前端将 `code` 传给后端 `/auth/oschina/callback`
4. 后端用 `code` 换取 OSCHINA token + 用户信息，生成自定义 JWT 返回
5. 前端将 JWT 存入 `flutter_secure_storage`
6. 后续请求在 `Authorization` 头携带 `Bearer <JWT>`
7. 后端 `security_api.py` 解析 JWT 并注入 `context.current_token`
8. `get_current_user()` 从 Redis/数据库获取用户 OSCHINA token

## 后端关键约定

- **响应封装**: 使用 `impl/utils.py` 中的 `success_response(data, msg)` 和 `error_response(data, msg, code)`
- **数据库**: SQLite（SQLAlchemy），`data.db`；Redis 用于 OSCHINA token 缓存
- **模型层**: `extra_models.py` 中的 Pydantic 模型（NewsSimple, NewsDetail, BlogSimple, BlogDetail, User, TokenModel）
- **认证**: `security_api.py` 的 `get_token_BearerAuth` 作为 Security dependency，自动验证 JWT 过期
- **OSCHINA 代理**: `impl/utils.py` 的 `oschina(path)` 拼接完整 URL，`headers` 包含 User-Agent 绕过限制
- **新加路由**: 在 `impl/default_api_impl.py` 中添加 `@router.xxx` 函数即可

## OSCHINA API 文档

- **本地副本**: `backend/oschina接口文档.html` — 这是一个 OpenAPI 3.0.1 规范的 HTML 文档，包含 OSCHINA 所有公开 API 端点的完整定义（请求参数、响应字段、类型说明）。
- **重要规则**: 在涉及 OSCHINA API 的响应字段、请求参数时，必须先查阅此文档确认。**不要猜测 API 字段名或假定存在某字段**（例如 `news_list` 接口不返回任何图片/封面图字段，而 `active_list` 接口返回 `tweetImage`）。如果文档中找不到所需信息，应向用户明确列出缺失了哪些信息。
- **后端当前实现**: `impl/default_api_impl.py` 中通过 `httpx` 调用 OSCHINA API，使用 `NewsSimple.model_validate(news)` 和 `BlogSimple.model_validate(blog)` 从原始 JSON 提取字段到 Pydantic 模型，忽略未定义字段。

## 前端关键约定

- **状态管理**: GetX（`Get.put`, `Get.find`, `Rx` 响应式变量）
- **网络请求**: 全局 `api` 变量（类型 `ApiClient`），经 `TokenInterceptor`（401 自动跳登录页）
- **响应解析**: `resp.data['data']` 获取业务数据层
- **持久化**: `StoreUtils.pref`（SharedPreferences）+ `StoreUtils.secure`（Keychain/EncryptedSharedPreferences）
- **数据模型**: `models/models.dart` 用 `freezed` 定义，JSON 序列化通过 `fromJson`/`toJson`

## 收藏管理

收藏功能在服务端未完全实现（缺少数据库收藏表），前端当前也未调用收藏 API。三个 endpoint 返回桩响应。