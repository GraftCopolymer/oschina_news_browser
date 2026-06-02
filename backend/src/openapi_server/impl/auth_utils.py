"""FastAPI 依赖注入式认证工具模块

参考项目: consumption_analyst_claude/back_end/src/openapi_server/utils/auth_utils.py

使用 FastAPI 的 Depends 机制, 将 Token 解析和用户查询整合为一个可复用的
依赖注入函数, 路由处理器只需声明 user: UserDep 即可获取当前用户对象。
"""

from typing import Annotated

import jwt
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from openapi_server.config.config import get_settings
from openapi_server.database.database import SessionLocal
from openapi_server.database.models import DBUser
from openapi_server.models.extra_models import User

bearer_scheme = HTTPBearer()


def parse_jwt(token_str: str) -> dict:
    """解析并验证 JWT Token

    自动完成以下工作：
    1. 验证签名是否正确
    2. 验证是否过期（检查 payload 中的 exp 字段）

    :param token_str: Bearer Token 字符串
    :return: 解析后的 payload 字典
    :raises HTTPException 401: Token 无效或已过期
    """
    try:
        payload = jwt.decode(
            token_str,
            get_settings().SECRET_KEY,
            [get_settings().JWT_ALGORITHM],
        )
        return payload
    except Exception:
        raise HTTPException(status_code=401, detail="无效的用户凭证")


async def get_current_user(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(bearer_scheme)],
) -> User:
    """FastAPI 依赖注入: 从 Authorization Header 提取 Bearer Token,
    解析 JWT, 查询数据库获取用户对象

    用法: ``user: UserDep``
    """
    payload = parse_jwt(credentials.credentials)
    user_id = int(payload["sub"])

    with SessionLocal() as db:
        db_user = db.query(DBUser).filter(DBUser.id == user_id).first()
        if not db_user:
            raise HTTPException(status_code=401, detail="用户不存在")
        return User.model_validate(db_user)


# 可复用的 FastAPI 依赖注入类型别名
# 用法: async def my_route(user: UserDep, ...):
UserDep = Annotated[User, Depends(get_current_user)]