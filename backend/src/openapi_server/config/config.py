from functools import lru_cache

from pydantic import Field, StrictStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8')

    APP_ID: str
    APP_SECRET: str
    REDIRECT_URL: str
    OSCHINA_BASE: str
    SECRET_KEY: str
    JWT_ALGORITHM: str
    ACCESS_TOKEN_EXPIRE_DAYS: int
    DATABASE_PATH: str

    # def redirect_url(self) -> StrictStr:
    #     return f"https://www.oschina.net/action/oauth2/authorize?response_type=code&client_id={get_settings().APP_ID}&redirect_uri={self.redirect_url}"


@lru_cache
def get_settings() -> Settings:
    return Settings()