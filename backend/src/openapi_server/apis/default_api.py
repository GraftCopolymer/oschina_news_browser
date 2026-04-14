# coding: utf-8

from typing import Dict, List  # noqa: F401
import importlib
import pkgutil

from openapi_server.apis.default_api_base import BaseDefaultApi
import openapi_server.impl

from fastapi import (  # noqa: F401
    APIRouter,
    Body,
    Cookie,
    Depends,
    Form,
    Header,
    HTTPException,
    Path,
    Query,
    Response,
    Security,
    status,
)

from openapi_server.models.extra_models import TokenModel  # noqa: F401
from pydantic import Field, StrictInt, StrictStr
from typing import Optional
from typing_extensions import Annotated
from openapi_server.models.api_response import ApiResponse
from openapi_server.models.collect_request import CollectRequest
from openapi_server.security_api import get_token_BearerAuth

router = APIRouter()

ns_pkg = openapi_server.impl
for _, name, _ in pkgutil.iter_modules(ns_pkg.__path__, ns_pkg.__name__ + "."):
    importlib.import_module(name)


@router.get(
    "/auth/oschina/authorize-url",
    responses={
        200: {"model": ApiResponse, "description": "请求成功"},
    },
    tags=["认证授权"],
    summary="获取OSCHINA授权链接",
    response_model_by_alias=True,
)
async def auth_oschina_authorize_url_get(
) -> ApiResponse:
    """客户端调用此接口获取授权URL，通过WebView打开进行登录授权"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().auth_oschina_authorize_url_get()


@router.get(
    "/auth/oschina/callback",
    responses={
        200: {"model": ApiResponse, "description": "登录成功"},
    },
    tags=["认证授权"],
    summary="OSCHINA授权回调接口",
    response_model_by_alias=True,
)
async def auth_oschina_callback_get(
    code: Annotated[StrictStr, Field(description="OSCHINA授权码")] = Query(None, description="OSCHINA授权码", alias="code"),
) -> ApiResponse:
    """授权成功后回调，后端自动换取OSCHINA Token并生成客户端JWT"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().auth_oschina_callback_get(code)


@router.post(
    "/auth/logout",
    responses={
        200: {"model": ApiResponse, "description": "请求成功"},
    },
    tags=["认证授权"],
    summary="退出登录",
    response_model_by_alias=True,
)
async def auth_logout_post(
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().auth_logout_post()


@router.get(
    "/news/list",
    responses={
        200: {"model": ApiResponse, "description": "获取成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["新闻管理"],
    summary="获取新闻列表",
    response_model_by_alias=True,
)
async def news_list_get(
    catalog: Annotated[Optional[StrictStr], Field(description="1=所有 2=综合新闻 3=软件更新")] = Query('1', description="1&#x3D;所有 2&#x3D;综合新闻 3&#x3D;软件更新", alias="catalog"),
    page: Optional[StrictStr] = Query('1', description="", alias="page"),
    page_size: Optional[StrictStr] = Query('20', description="", alias="pageSize"),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义适配列表"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().news_list_get(catalog, page, page_size)


@router.get(
    "/news/detail/{id}",
    responses={
        200: {"model": ApiResponse, "description": "获取成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["新闻管理"],
    summary="获取新闻详情",
    response_model_by_alias=True,
)
async def news_detail_id_get(
    id: Annotated[StrictStr, Field(description="新闻ID")] = Path(..., description="新闻ID"),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义详情数据"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().news_detail_id_get(id)


@router.get(
    "/blog/list",
    responses={
        200: {"model": ApiResponse, "description": "获取成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["博客管理"],
    summary="获取博客列表",
    response_model_by_alias=True,
)
async def blog_list_get(
    page: Optional[StrictInt] = Query(1, description="", alias="page"),
    page_size: Optional[StrictInt] = Query(20, description="", alias="pageSize"),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义适配列表"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().blog_list_get(page, page_size)


@router.get(
    "/blog/detail/{id}",
    responses={
        200: {"model": ApiResponse, "description": "获取成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["博客管理"],
    summary="获取博客详情",
    response_model_by_alias=True,
)
async def blog_detail_id_get(
    id: Annotated[StrictInt, Field(description="博客ID")] = Path(..., description="博客ID"),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义详情数据"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().blog_detail_id_get(id)


@router.get(
    "/search",
    responses={
        200: {"model": ApiResponse, "description": "搜索成功"},
        401: {"model": ApiResponse, "description": "未授权/登录失效"},
    },
    tags=["搜索功能"],
    summary="全局搜索",
    response_model_by_alias=True,
)
async def search_get(
    q: Annotated[StrictStr, Field(description="搜索关键词")] = Query(None, description="搜索关键词", alias="q"),
    catalog: Annotated[Optional[StrictStr], Field(description="搜索类型, 取值 news, blog, project, post")] = Query('news', description="搜索类型, 取值 news, blog, project, post", alias="catalog"),
    page: Optional[StrictInt] = Query(1, description="", alias="page"),
    page_size: Optional[StrictInt] = Query(20, description="", alias="pageSize"),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    """支持搜索新闻、博客，后端代理OSCHINA搜索接口"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().search_get(q, catalog, page, page_size)


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
    collect_request: CollectRequest = Body(None, description=""),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    """保存收藏类型+ID，后端关联用户"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().collect_add_post(collect_request)


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
    collect_request: CollectRequest = Body(None, description=""),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().collect_remove_post(collect_request)


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
    page: Optional[StrictInt] = Query(1, description="", alias="page"),
    page_size: Optional[StrictInt] = Query(20, description="", alias="pageSize"),
    token_BearerAuth: TokenModel = Security(
        get_token_BearerAuth
    ),
) -> ApiResponse:
    """后端根据收藏ID批量请求OSCHINA，返回列表数据"""
    if not BaseDefaultApi.subclasses:
        raise HTTPException(status_code=500, detail="Not implemented")
    return await BaseDefaultApi.subclasses[0]().collect_list_get(page, page_size)
