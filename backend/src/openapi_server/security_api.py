import jwt
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from openapi_server.config.config import get_settings
from openapi_server.context import current_token
from openapi_server.models.extra_models import TokenModel


bearer_auth = HTTPBearer()


async def get_token_BearerAuth(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_auth),
) -> TokenModel:
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
        payload = jwt.decode(
            token_str,
            get_settings().SECRET_KEY,
            [get_settings().JWT_ALGORITHM],
        )
        token_model = TokenModel(sub=payload.get("sub"), raw_token=token_str)
        # 存入上下文变量
        current_token.set(token_model)
        return token_model
    except Exception as e:
        raise HTTPException(status_code=401, detail="无效的用户凭证")