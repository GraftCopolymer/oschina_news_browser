from datetime import datetime, timedelta

import httpx
import jwt
from fastapi import HTTPException
from pydantic import StrictStr, StrictInt
from typing_extensions import Optional, Dict, Any

from openapi_server.config.config import get_settings
from openapi_server.context import current_token
from openapi_server.database.database import SessionLocal
from openapi_server.database.models import DBUser
from openapi_server.impl.default_api_impl import redis_client
from openapi_server.models.api_response import ApiResponse
from openapi_server.models.extra_models import TokenModel, User

headers = {
    "User-Agent": "Mozilla/5.0" # 不加这个 OSCHINA 不会允许访问
}

def success_response(data: Optional[Dict[str, Any]], code: Optional[StrictInt] = 200, msg: Optional[StrictStr] = "") -> ApiResponse:
    return ApiResponse(
        code=code,
        msg=msg,
        data=data,
    )

def error_response(data: Optional[Dict[str, Any]], code: Optional[StrictInt] = 400, msg: Optional[StrictStr] = "") -> ApiResponse:
    return ApiResponse(
        code=code,
        msg=msg,
        data=data,
    )

def oschina(path: StrictStr) -> StrictStr:
    return f'{get_settings().OSCHINA_BASE}{path}'

# expires_in: 过期时间(s)
def create_app_jwt(user_id: int, expire_stamp: int) -> StrictStr:
    """生成自定义 App JWT"""
    to_encode = {"sub": f'{user_id}', "exp": expire_stamp}
    encoded_jwt = jwt.encode(to_encode, get_settings().SECRET_KEY, algorithm= get_settings().JWT_ALGORITHM)
    return encoded_jwt

async def oschina_code2token(code: StrictStr):
    """通过授权码获取 OSCHINA 的 token 和 refresh_token"""
    url = oschina("/action/openapi/token")
    data = {
        "grant_type": "authorization_code",
        "client_id": get_settings().APP_ID,
        "client_secret": get_settings().APP_SECRET,
        "redirect_uri": get_settings().REDIRECT_URL,
        "code": code,
        'dataType': 'json',
    }
    async with httpx.AsyncClient() as client:
        resp = await client.post(url, data=data, headers=headers)
        if resp.status_code != 200:
            raise HTTPException(400, "OSCHINA授权失败")
        return resp.json()

async def fetch_user_info(access_token: StrictStr):
    async with httpx.AsyncClient() as client:
        resp = await client.post(oschina('/action/openapi/user'), data={
            'access_token': access_token,
        }, headers=headers)
        if resp.status_code != 200:
            raise HTTPException(400, "获取用户信息失败")
        return resp.json()

def get_current_token_model() -> TokenModel:
    token_model = current_token.get()
    if not token_model:
        raise HTTPException(status_code=401, detail="未提供用户 Token")
    return token_model

async def get_current_user() -> User:
    token_model = get_current_token_model()
    # 从 Redis 中寻找用户信息
    oschina_token_string: Optional[StrictStr] = redis_client.get(token_model.sub)
    user_uid = int(token_model.sub)
    user: Optional[User] = None
    if oschina_token_string: # Redis中有缓存
        print("从 Redis 中读取用户成功")
        with SessionLocal() as db:
            db_user: DBUser = db.query(DBUser).filter(DBUser.id == user_uid).first()
            # 数据库中肯定存在该用户
            user = User.model_validate(db_user)
    else: # Redis 中无缓存
         print("从 Redis 中读取用户失败, 尝试在数据库查找")
         with SessionLocal() as db:
            db_user: Optional[DBUser] = db.query(DBUser).filter(DBUser.id == user_uid).first()
            if not db_user:
                raise HTTPException(status_code=401, detail="用户不存在")
            user = User.model_validate(db_user)
    return user