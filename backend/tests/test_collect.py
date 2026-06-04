"""Tests for collect feature."""

import pytest
from pydantic import ValidationError

from openapi_server.models.collect_request import CollectRequest
from openapi_server.impl.utils import (
    success_response,
    error_response,
)


class TestCollectRequest:
    def test_valid_news(self):
        req = CollectRequest(targetType="news", targetId=123)
        assert req.target_type == "news"
        assert req.target_id == 123

    def test_valid_blog(self):
        req = CollectRequest(targetType="blog", targetId=456)
        assert req.target_type == "blog"

    def test_invalid_type(self):
        with pytest.raises(ValidationError):
            CollectRequest(targetType="project", targetId=1)