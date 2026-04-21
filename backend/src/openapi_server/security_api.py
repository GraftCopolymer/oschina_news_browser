# coding: utf-8

from typing import List

import jwt
from fastapi import Depends, Security, HTTPException  # noqa: F401
from fastapi.openapi.models import OAuthFlowImplicit, OAuthFlows  # noqa: F401
from fastapi.security import (  # noqa: F401
    HTTPAuthorizationCredentials,
    HTTPBasic,
    HTTPBasicCredentials,
    HTTPBearer,
    OAuth2,
    OAuth2AuthorizationCodeBearer,
    OAuth2PasswordBearer,
    SecurityScopes,
)
from fastapi.security.api_key import APIKeyCookie, APIKeyHeader, APIKeyQuery  # noqa: F401

from openapi_server.config.config import get_settings
from openapi_server.context import current_token
from openapi_server.models.extra_models import TokenModel


bearer_auth = HTTPBearer()


async def get_token_BearerAuth(credentials: HTTPAuthorizationCredentials = Depends(bearer_auth)) -> TokenModel:
    """
    Check and retrieve authentication information from custom bearer token.

    :param credentials Credentials provided by Authorization header
    :type credentials: HTTPAuthorizationCredentials
    :return: Decoded token information or None if token is invalid
    :rtype: TokenModel | None
    """
    token_str = credentials.credentials
    try:
        # 注意这里会自动验证过期, 若过期会抛出异常
        payload = jwt.decode(token_str, get_settings().SECRET_KEY, [get_settings().JWT_ALGORITHM])
        token_model = TokenModel(sub=payload.get('sub'), raw_token=token_str)
        # 存入上下文变量
        current_token.set(token_model)
        return token_model
    except Exception as e:
        raise HTTPException(status_code=401, detail="无效的用户凭证")

oauth2_code = OAuth2AuthorizationCodeBearer(
    authorizationUrl="https://www.oschina.net/action/oauth2/authorize",
    tokenUrl="https://www.oschina.net/action/openapi/token",
    refreshUrl="",
    scopes={
        "read:news": "读取新闻资讯",
        "read:blog": "读取博客信息",
        "read:search": "搜索功能",
    }
)


def get_token_OSCHINA_OAuth2(
    security_scopes: SecurityScopes, token: str = Depends(oauth2_code)
) -> TokenModel:
    """
    Validate and decode token.

    :param token Token provided by Authorization header
    :type token: str
    :return: Decoded token information or None if token is invalid
    :rtype: TokenModel | None
    """

    ...


def validate_scope_OSCHINA_OAuth2(
    required_scopes: SecurityScopes, token_scopes: List[str]
) -> bool:
    """
    Validate required scopes are included in token scope

    :param required_scopes Required scope to access called API
    :type required_scopes: List[str]
    :param token_scopes Scope present in token
    :type token_scopes: List[str]
    :return: True if access to called API is allowed
    :rtype: bool
    """

    return False

