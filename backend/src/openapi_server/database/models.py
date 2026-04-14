from sqlalchemy import Column, Integer, String

from openapi_server.database.database import Base


class DBUser(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True, autoincrement=False)
    app_token = Column(String, unique=True, index=True)
    oschina_token = Column(String, unique=True, index=True)
    oschina_refresh_token = Column(String, unique=True, index=True)