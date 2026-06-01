import json
from datetime import datetime, timedelta

import httpx
from fastapi import APIRouter, HTTPException, Query, Path, Body, Security, status
from pydantic import StrictStr, Field, StrictInt
from typing_extensions import Annotated, Optional

from openapi_server.config.config import get_settings
from openapi_server.database.database import SessionLocal
from openapi_server.database.models import DBUser
from openapi_server.database.redis import redis_client
from openapi_server.impl.utils import (
    success_response, oschina_code2token, error_response, create_app_jwt,
    fetch_user_info, oschina, get_current_user, headers,
)
from openapi_server.models.api_response import ApiResponse
from openapi_server.models.auth_token import AuthToken
from openapi_server.models.collect_request import CollectRequest
from openapi_server.models.extra_models import NewsSimple, NewsDetail, BlogSimple, BlogDetail, TokenModel
from openapi_server.security_api import get_token_BearerAuth

router = APIRouter()

auth_url = (
    f"https://www.oschina.net/action/oauth2/authorize"
    f"?response_type=code&client_id={get_settings().APP_ID}"
    f"&redirect_uri={get_settings().REDIRECT_URL}"
)


# ──────────────────────────────────────────────
#  认证授权
# ──────────────────────────────────────────────

@router.get(
    "/auth/oschina/authorize-url",
    responses={200: {"model": ApiResponse, "description": "请求成功"}},
    tags=["认证授权"],
    summary="获取OSCHINA授权链接",
    response_model_by_alias=True,
)
async def auth_oschina_authorize_url_get() -> ApiResponse:
    """客户端调用此接口获取授权URL，通过WebView打开进行登录授权"""
    return success_response({"auth_url": auth_url})


@router.get(
    "/auth/oschina/callback",
    responses={200: {"model": ApiResponse, "description": "登录成功"}},
    tags=["认证授权"],
    summary="OSCHINA授权回调接口",
    response_model_by_alias=True,
)
async def auth_oschina_callback_get(
    code: Annotated[StrictStr, Field(description="OSCHINA授权码")] = Query(
        None, description="OSCHINA授权码", alias="code"
    ),
) -> ApiResponse:
    """授权成功后回调，后端自动换取OSCHINA Token并生成客户端JWT"""
    try:
        token_info = await oschina_code2token(code)
        token = token_info["access_token"]
        refresh_token = token_info["refresh_token"]
        expires_in = token_info["expires_in"]
        user_uid = token_info["uid"]
        expire = datetime.utcnow() + timedelta(seconds=expires_in)
        jwt_token = create_app_jwt(
            user_id=user_uid, expire_stamp=int(expire.timestamp())
        )

        # 保存用户到数据库
        db_user = DBUser(
            id=user_uid,
            app_token=jwt_token,
            oschina_token=token,
            oschina_refresh_token=refresh_token,
        )
        with SessionLocal() as db:
            db.merge(db_user)
            try:
                db.commit()
            except Exception as e:
                print(e)
                raise HTTPException(status_code=500, detail="用户注册失败")

        # 保存到 Redis
        redis_client.set(
            user_uid,
            json.dumps({"token": token, "refresh_token": refresh_token}),
        )

        # 请求用户信息
        user_info_resp = await fetch_user_info(token)
        user_info = {
            "username": user_info_resp["name"],
            "email": user_info_resp["email"],
            "avatar": user_info_resp["avatar"],
            "userId": user_info_resp["id"],
        }
        return success_response(
            data={
                "data": AuthToken(
                    accessToken=jwt_token,
                    expiresIn=expires_in,
                    userInfo=user_info,
                )
            }
        )
    except HTTPException as e:
        return error_response(data=None, msg=e.detail)


@router.post(
    "/auth/logout",
    responses={200: {"model": ApiResponse, "description": "请求成功"}},
    tags=["认证授权"],
    summary="退出登录",
    response_model_by_alias=True,
)
async def auth_logout_post(
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    # 客户端退出登录已清除本地存储，服务端无状态 JWT 无需额外操作
    return success_response(data=None, msg="已退出登录")


# ──────────────────────────────────────────────
#  新闻管理
# ──────────────────────────────────────────────

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
    catalog: Annotated[
        Optional[StrictStr], Field(description="1=所有 2=综合新闻 3=软件更新")
    ] = Query("1", description="1=所有 2=综合新闻 3=软件更新", alias="catalog"),
    page: Optional[StrictStr] = Query("1", description="", alias="page"),
    page_size: Optional[StrictStr] = Query("20", description="", alias="pageSize"),
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义适配列表"""
    user = await get_current_user()
    async with httpx.AsyncClient() as client:
        url = oschina("/action/openapi/news_list")
        resp = await client.post(
            url,
            data={
                "access_token": user.oschina_token,
                "catalog": 3,
                "page": page,
                "pageSize": page_size,
            },
            headers=headers,
        )
        if resp.status_code != 200:
            print(resp)
            raise HTTPException(status_code=500, detail="服务器错误")
        news_list = []
        oschina_data = resp.json()
        for news in oschina_data["newslist"]:
            news_list.append(NewsSimple.model_validate(news))
        return success_response(data={"news_list": news_list})


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
    id: Annotated[StrictStr, Field(description="新闻ID")] = Path(
        ..., description="新闻ID"
    ),
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义详情数据"""
    user = await get_current_user()
    async with httpx.AsyncClient() as client:
        try:
            resp = await client.post(
                oschina("/action/openapi/news_detail"),
                data={
                    "id": id,
                    "access_token": user.oschina_token,
                },
                headers=headers,
            )
            if resp.status_code != 200:
                raise HTTPException(
                    status_code=resp.status_code,
                    detail=f"获取新闻详情失败 {resp.status_code}",
                )
            news_data = resp.json()
            news_detail = NewsDetail.model_validate(news_data)
            return success_response(data={"news_detail": news_detail.model_dump()})
        except Exception as e:
            print(e)
            raise HTTPException(status_code=500, detail="服务器错误")


# ──────────────────────────────────────────────
#  博客管理
# ──────────────────────────────────────────────

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
    page: Optional[StrictStr] = Query("1", description="", alias="page"),
    page_size: Optional[StrictStr] = Query("20", description="", alias="pageSize"),
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义适配列表"""
    user = await get_current_user()

    async with httpx.AsyncClient() as client:
        url = oschina("/action/openapi/blog_recommend_list")
        resp = await client.post(
            url,
            data={
                "access_token": user.oschina_token,
                "page": page,
                "pageSize": page_size,
            },
            headers=headers,
        )

        if resp.status_code != 200:
            print(f"OSChina Blog API Error: {resp.text}")
            raise HTTPException(status_code=500, detail="服务器错误")

        blog_list = []
        oschina_data = resp.json()

        for blog in oschina_data.get("bloglist", []):
            blog_list.append(BlogSimple.model_validate(blog))

        return success_response(data={"blog_list": blog_list})


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
    id: Annotated[StrictStr, Field(description="博客ID")] = Path(
        ..., description="博客ID"
    ),
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    """后端代理OSCHINA接口，返回自定义详情数据"""
    user = await get_current_user()

    async with httpx.AsyncClient() as client:
        try:
            resp = await client.post(
                oschina("/action/openapi/blog_detail"),
                data={
                    "id": id,
                    "access_token": user.oschina_token,
                },
                headers=headers,
            )

            if resp.status_code != 200:
                print(f"OSChina Blog Detail API Error: {resp.text}")
                raise HTTPException(
                    status_code=resp.status_code,
                    detail=f"获取博客详情失败 {resp.status_code}",
                )

            blog_data = resp.json()
            blog_detail = BlogDetail.model_validate(blog_data)

            return success_response(
                data={"blog_detail": blog_detail.model_dump()}
            )

        except Exception as e:
            print(f"Exception in blog_detail_id_get: {e}")
            raise HTTPException(status_code=500, detail="服务器错误")


# ──────────────────────────────────────────────
#  搜索功能
# ──────────────────────────────────────────────

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
    q: Annotated[StrictStr, Field(description="搜索关键词")] = Query(
        None, description="搜索关键词", alias="q"
    ),
    catalog: Annotated[
        Optional[StrictStr],
        Field(description="搜索类型, 取值 news, blog, project, post"),
    ] = Query("news", description="搜索类型, 取值 news, blog, project, post", alias="catalog"),
    page: Optional[StrictInt] = Query(1, description="", alias="page"),
    page_size: Optional[StrictInt] = Query(20, description="", alias="pageSize"),
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    """支持搜索新闻、博客，后端代理OSCHINA搜索接口"""
    user = await get_current_user()
    async with httpx.AsyncClient() as client:
        try:
            resp = await client.post(
                oschina("/action/openapi/search"),
                data={
                    "access_token": user.oschina_token,
                    "q": q,
                    "catalog": catalog,
                    "page": page,
                    "pageSize": page_size,
                },
                headers=headers,
            )
            if resp.status_code != 200:
                print(f"OSChina Search API Error: {resp.text}")
                raise HTTPException(
                    status_code=resp.status_code,
                    detail=f"搜索失败 {resp.status_code}",
                )
            result = resp.json()
            return success_response(data=result)
        except Exception as e:
            print(f"Exception in search_get: {e}")
            raise HTTPException(status_code=500, detail="服务器错误")


# ──────────────────────────────────────────────
#  收藏管理
# ──────────────────────────────────────────────

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
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    """保存收藏类型+ID，后端关联用户"""
    # TODO: 实现后端收藏逻辑（需要添加收藏数据库表）
    # user = await get_current_user()
    return success_response(data=None, msg="收藏成功（暂未持久化）")


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
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    # TODO: 实现后端取消收藏逻辑
    return success_response(data=None, msg="已取消收藏（暂未持久化）")


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
    token_BearerAuth: TokenModel = Security(get_token_BearerAuth),
) -> ApiResponse:
    """后端根据收藏ID批量请求OSCHINA，返回列表数据"""
    # TODO: 实现后端收藏列表逻辑
    return success_response(data={"list": [], "total": 0, "page": page, "pageSize": page_size})