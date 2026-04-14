# coding: utf-8

from fastapi.testclient import TestClient


from pydantic import Field, StrictInt, StrictStr, field_validator  # noqa: F401
from typing import Optional  # noqa: F401
from typing_extensions import Annotated  # noqa: F401
from openapi_server.models.api_response import ApiResponse  # noqa: F401
from openapi_server.models.collect_request import CollectRequest  # noqa: F401


def test_auth_oschina_authorize_url_get(client: TestClient):
    """Test case for auth_oschina_authorize_url_get

    获取OSCHINA授权链接
    """

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/auth/oschina/authorize-url",
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_auth_oschina_callback_get(client: TestClient):
    """Test case for auth_oschina_callback_get

    OSCHINA授权回调接口
    """
    params = [("code", 'code_example')]
    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/auth/oschina/callback",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_auth_logout_post(client: TestClient):
    """Test case for auth_logout_post

    退出登录
    """

    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/auth/logout",
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_news_list_get(client: TestClient):
    """Test case for news_list_get

    获取新闻列表
    """
    params = [("catalog", 1),     ("page", 1),     ("page_size", 20)]
    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/news/list",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_news_detail_id_get(client: TestClient):
    """Test case for news_detail_id_get

    获取新闻详情
    """

    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/news/detail/{id}".format(id=56),
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_blog_list_get(client: TestClient):
    """Test case for blog_list_get

    获取博客列表
    """
    params = [("page", 1),     ("page_size", 20)]
    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/blog/list",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_blog_detail_id_get(client: TestClient):
    """Test case for blog_detail_id_get

    获取博客详情
    """

    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/blog/detail/{id}".format(id=56),
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_search_get(client: TestClient):
    """Test case for search_get

    全局搜索
    """
    params = [("q", 'q_example'),     ("catalog", news),     ("page", 1),     ("page_size", 20)]
    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/search",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_collect_add_post(client: TestClient):
    """Test case for collect_add_post

    添加收藏（新闻/博客）
    """
    collect_request = {"target_id":26754,"target_type":"news"}

    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/collect/add",
    #    headers=headers,
    #    json=collect_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_collect_remove_post(client: TestClient):
    """Test case for collect_remove_post

    取消收藏
    """
    collect_request = {"target_id":26754,"target_type":"news"}

    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/collect/remove",
    #    headers=headers,
    #    json=collect_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_collect_list_get(client: TestClient):
    """Test case for collect_list_get

    获取我的收藏列表
    """
    params = [("page", 1),     ("page_size", 20)]
    headers = {
        "Authorization": "Bearer special-key",
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/collect/list",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

