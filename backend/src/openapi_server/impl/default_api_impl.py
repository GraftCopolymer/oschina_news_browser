import json
from datetime import datetime, timedelta

import httpx
from fastapi import HTTPException
from pydantic import StrictStr, Field, StrictInt
from typing_extensions import Annotated, Optional

from openapi_server.apis.default_api_base import BaseDefaultApi
from openapi_server.config.config import get_settings
from openapi_server.database.database import SessionLocal
from openapi_server.database.models import DBUser
from openapi_server.database.redis import redis_client
from openapi_server.impl.utils import success_response, oschina_code2token, error_response, create_app_jwt, \
    fetch_user_info, oschina, get_current_user, headers
from openapi_server.models.api_response import ApiResponse
from openapi_server.models.auth_token import AuthToken
from openapi_server.models.extra_models import NewsSimple, NewsDetail


class DefaultApiImpl(BaseDefaultApi):
    def __init__(self):
        self.auth_url = f"https://www.oschina.net/action/oauth2/authorize?response_type=code&client_id={get_settings().APP_ID}&redirect_uri={get_settings().REDIRECT_URL}"

    async def auth_oschina_authorize_url_get(self) -> ApiResponse:
        return success_response({
            "auth_url": self.auth_url
        })

    async def auth_oschina_callback_get(
            self,
            code: Annotated[StrictStr, Field(description="OSCHINA授权码")],
    ) -> ApiResponse:
        """授权成功后回调，后端自动换取OSCHINA Token并生成客户端JWT"""
        try:
            token_info = await oschina_code2token(code)
            token = token_info['access_token']
            refresh_token = token_info['refresh_token']
            expires_in = token_info['expires_in']
            user_uid = token_info['uid']
            expire = datetime.utcnow() + timedelta(seconds=expires_in)
            jwt = create_app_jwt(user_id=user_uid, expire_stamp=int(expire.timestamp()))

            # 保存用户到数据库
            db_user = DBUser(
                id=user_uid,
                app_token=jwt,
                oschina_token=token,
                oschina_refresh_token=refresh_token
            )
            with SessionLocal() as db:
                db_user_ = db.query(DBUser).filter(DBUser.id == db_user.id).first()
                if not db_user_: # 用户不存在才添加, 存在则修改对应的字段
                    db.merge(db_user)
                    try:
                        db.commit()
                    except Exception as e:
                        print(e)
                        raise HTTPException(status_code=500, detail="用户注册失败")

            # 保存到 Redis
            redis_client.set(jwt, json.dumps({
                'token': token,
                'refresh_token': refresh_token
            }))
            # 请求用户信息
            userInfoResp = await fetch_user_info(token)
            userInfo = {
                'username': userInfoResp['name'],
                'email': userInfoResp['email'],
                'avatar': userInfoResp['avatar'],
                'userId': userInfoResp['id'],
            }
            return success_response({
                "data": AuthToken(accessToken=jwt, expiresIn=expires_in, userInfo=userInfo)
            })
        except HTTPException as e:
            return error_response(data=None, msg=e.detail)

    async def news_list_get(
            self,
            catalog: Annotated[Optional[StrictStr], Field(description="1=所有 2=综合新闻 3=软件更新")],
            page: Optional[StrictStr],
            page_size: Optional[StrictStr],
    ) -> ApiResponse:
        """后端代理OSCHINA接口，返回自定义适配列表"""
        user = await get_current_user()
        async with httpx.AsyncClient() as client:
            url = oschina("/action/openapi/news_list")
            custom_headers = {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
                "Referer": "https://www.oschina.net/",
                "Accept": "application/json"
            }
            resp = await client.post(url, data={
                'access_token': user.oschina_token,
                'catalog': 1,
                'page': page,
                'pageSize': page_size
            }, headers=custom_headers)
            if resp.status_code != 200:
                print(resp)
                raise HTTPException(status_code=500, detail="服务器错误")
            news_list = []
            oschina_data = resp.json()
            for news in oschina_data['newslist']:
                news_list.append(NewsSimple.model_validate(news))
            return success_response(data={
                'news_list': news_list
            })

    async def news_detail_id_get(
        self,
        id: Annotated[StrictStr, Field(description="新闻ID")],
    ) -> ApiResponse:
        """后端代理OSCHINA接口，返回自定义详情数据"""
        user = await get_current_user()
        async with httpx.AsyncClient() as client:
            try:
                resp = await client.post(oschina('/action/openapi/news_detail'), data={
                    'id': id,
                    'access_token': user.oschina_token,
                }, headers=headers)
                if resp.status_code != 200:
                    raise HTTPException(status_code=resp.status_code, detail=f"获取新闻详情失败 {resp.status_code}")
                news_data = resp.json()
                news_detail = NewsDetail.model_validate(news_data)
                return success_response(data={
                    'news_detail': news_detail.model_dump()
                })
            except Exception as e:
                print(e)
                raise HTTPException(status_code=500, detail="服务器错误")
