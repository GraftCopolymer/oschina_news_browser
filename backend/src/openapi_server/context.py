from contextvars import ContextVar
from typing import Optional
from openapi_server.models.extra_models import TokenModel, User

# 创建一个全局上下文变量，用于存储解析后的 Token 信息
current_token: ContextVar[Optional[TokenModel]] = ContextVar("current_token", default=None)

current_user: ContextVar[Optional[User]] = ContextVar("current_user", default=None)