"""Tests for backend utility functions."""

import jwt
import pytest
from pydantic import StrictStr

from openapi_server.impl.utils import (
    success_response,
    error_response,
    oschina,
    create_app_jwt,
)


class TestSuccessResponse:
    def test_with_data(self):
        resp = success_response(data={"key": "value"})
        assert resp.code == 200
        assert resp.msg == ""
        assert resp.data == {"key": "value"}

    def test_with_custom_msg(self):
        resp = success_response(data=None, msg="操作成功")
        assert resp.code == 200
        assert resp.msg == "操作成功"
        assert resp.data is None

    def test_with_custom_code(self):
        resp = success_response(data={}, code=201)
        assert resp.code == 201
        assert resp.data == {}


class TestErrorResponse:
    def test_default_error(self):
        resp = error_response(data=None)
        assert resp.code == 400
        assert resp.data is None

    def test_with_message(self):
        resp = error_response(data={}, msg="参数错误")
        assert resp.code == 400
        assert resp.msg == "参数错误"
        assert resp.data == {}

    def test_custom_code(self):
        resp = error_response(data=None, code=403, msg="禁止访问")
        assert resp.code == 403
        assert resp.msg == "禁止访问"


class TestOschina:
    def test_url_construction(self):
        url = oschina("/action/openapi/news_list")
        assert url == "https://www.oschina.net/action/openapi/news_list"

    def test_url_construction_without_leading_slash(self):
        # oschina() 不做路径归一化，不含 / 时直接拼接
        url = oschina("action/openapi/news_detail")
        assert url == "https://www.oschina.netaction/openapi/news_detail"


class TestCreateAppJwt:
    def test_jwt_contains_user_id(self):
        token = create_app_jwt(user_id=42, expire_stamp=9999999999)
        payload = jwt.decode(token, options={"verify_signature": False})
        assert payload["sub"] == "42"

    def test_jwt_contains_expire_stamp(self):
        token = create_app_jwt(user_id=1, expire_stamp=2000000000)
        payload = jwt.decode(token, options={"verify_signature": False})
        assert payload["exp"] == 2000000000

    def test_jwt_type_is_string(self):
        token = create_app_jwt(user_id=7, expire_stamp=1000000000)
        assert isinstance(token, str)
        assert len(token) > 20

    def test_different_users_produce_different_tokens(self):
        token1 = create_app_jwt(user_id=1, expire_stamp=9999999999)
        token2 = create_app_jwt(user_id=2, expire_stamp=9999999999)
        assert token1 != token2