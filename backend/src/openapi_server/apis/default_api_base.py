# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from pydantic import Field, StrictInt, StrictStr
from typing import Optional
from typing_extensions import Annotated
from openapi_server.models.api_response import ApiResponse
from openapi_server.models.collect_request import CollectRequest
from openapi_server.security_api import get_token_BearerAuth

class BaseDefaultApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseDefaultApi.subclasses = BaseDefaultApi.subclasses + (cls,)
    async def auth_oschina_authorize_url_get(
        self,
    ) -> ApiResponse:
        """客户端调用此接口获取授权URL，通过WebView打开进行登录授权"""
        ...


    async def auth_oschina_callback_get(
        self,
        code: Annotated[StrictStr, Field(description="OSCHINA授权码")],
    ) -> ApiResponse:
        """授权成功后回调，后端自动换取OSCHINA Token并生成客户端JWT"""
        ...


    async def auth_logout_post(
        self,
    ) -> ApiResponse:
        ...


    async def news_list_get(
        self,
        catalog: Annotated[Optional[StrictStr], Field(description="1=所有 2=综合新闻 3=软件更新")],
        page: Optional[StrictStr],
        page_size: Optional[StrictStr],
    ) -> ApiResponse:
        """后端代理OSCHINA接口，返回自定义适配列表"""
        ...


    async def news_detail_id_get(
        self,
        id: Annotated[StrictStr, Field(description="新闻ID")],
    ) -> ApiResponse:
        """后端代理OSCHINA接口，返回自定义详情数据"""
        ...


    async def blog_list_get(
        self,
        page: Optional[StrictInt],
        page_size: Optional[StrictInt],
    ) -> ApiResponse:
        """后端代理OSCHINA接口，返回自定义适配列表"""
        ...


    async def blog_detail_id_get(
        self,
        id: Annotated[StrictInt, Field(description="博客ID")],
    ) -> ApiResponse:
        """后端代理OSCHINA接口，返回自定义详情数据"""
        ...


    async def search_get(
        self,
        q: Annotated[StrictStr, Field(description="搜索关键词")],
        catalog: Annotated[Optional[StrictStr], Field(description="搜索类型, 取值 news, blog, project, post")],
        page: Optional[StrictInt],
        page_size: Optional[StrictInt],
    ) -> ApiResponse:
        """支持搜索新闻、博客，后端代理OSCHINA搜索接口"""
        ...


    async def collect_add_post(
        self,
        collect_request: CollectRequest,
    ) -> ApiResponse:
        """保存收藏类型+ID，后端关联用户"""
        ...


    async def collect_remove_post(
        self,
        collect_request: CollectRequest,
    ) -> ApiResponse:
        ...


    async def collect_list_get(
        self,
        page: Optional[StrictInt],
        page_size: Optional[StrictInt],
    ) -> ApiResponse:
        """后端根据收藏ID批量请求OSCHINA，返回列表数据"""
        ...
