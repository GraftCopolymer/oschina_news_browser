"""
    OSCHINA IT资讯APP后端API

    基于FastAPI开发的OSCHINA资讯代理后端API：
    1. 集成OSCHINA OAuth2.0授权登录
    2. 后端代理所有OSCHINA OpenAPI请求，客户端无直接调用
    3. 支持新闻/博客列表/详情、全局搜索
    4. 自定义用户收藏功能（新闻/博客收藏管理）
    5. 自定义数据模型适配Flutter客户端展示需求
"""

from fastapi import FastAPI

from openapi_server.database.database import engine, Base
from openapi_server.impl.default_api_impl import router as DefaultApiRouter

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="OSCHINA IT资讯APP后端API",
    description=(
        "基于FastAPI开发的OSCHINA资讯代理后端API。"
        "集成OSCHINA OAuth2.0授权登录，后端代理所有OSCHINA OpenAPI请求。"
        "支持新闻/博客列表/详情、全局搜索。"
    ),
    version="1.0.0",
)

app.include_router(DefaultApiRouter)