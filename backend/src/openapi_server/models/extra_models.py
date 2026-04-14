# coding: utf-8

from pydantic import BaseModel, ConfigDict, Field


class TokenModel(BaseModel):
    """Defines a token model."""

    sub: str
    raw_token: str

class NewsItem(BaseModel):
    id: int
    author: str
    pubDate: str
    title: str
    authorid: int
    commentCount: int
    type: int

class User(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    app_token: str
    oschina_token: str
    oschina_refresh_token: str

class NewsSimple(BaseModel):
    id: int
    author: str
    pubDate: str
    title: str
    authorid: int
    commentCount: int
    type: int

class NewsDetail(BaseModel):
    id: int
    body: str
    pubDate: str
    author: str
    title: str
    authorid: int
