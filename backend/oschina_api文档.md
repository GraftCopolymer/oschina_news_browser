---
title: 默认模块
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers: []
includes: []
search: true
code_clipboard: true
highlight_theme: darkula
headingLevel: 2
generator: "@tarslib/widdershins v4.0.30"

---

# 默认模块

Base URLs:

* <a href="https://www.oschina.net">正式环境: https://www.oschina.net</a>

# Authentication

# 认证接口

## GET oauth2_authorize

GET /action/oauth2/authorize

| 错误代码 | 错误标识               | 说明                     |
| -------- | ---------------------- | ------------------------ |
| 400      | invalid_request        | 无效请求（缺少必要参数） |
| 401      | invalid_client         | client_id无效            |
| 401      | invalid_grant          | 授权方式无效             |
| 401      | unauthorized_client    | 应用未授权               |
| 401      | unsupported_grant_type | 不支持的授权方式         |

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|response_type|query|string| 否 |返回数据类型|
|client_id|query|string| 否 |OAuth2客户ID|
|state|query|string| 否 |可选参数|
|redirect_uri|query|string| 否 |回调地址|

> 返回示例

> 200 Response

```json
{
  "code": "string",
  "state": "string"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» code|string|true|none|授权码|none|
|» state|string|true|none|应用传递的可选参数|none|

## POST oauth2_token

POST /action/openapi/token

支持格式：JSON JSONP XML

HTTP请求方式：GET/POST

错误说明

| 错误代码 | 错误标识               | 说明                     |
| -------- | ---------------------- | ------------------------ |
| 400      | invalid_request        | 无效请求（缺少必要参数） |
| 401      | invalid_client         | client_id无效            |
| 401      | invalid_grant          | 授权方式无效             |
| 401      | unauthorized_client    | 应用未授权               |
| 401      | unsupported_grant_type | 不支持的授权方式         |

> Body 请求参数

```json
{
  "client_id": "string",
  "client_secret": "string",
  "grant_type": "string",
  "redirect_uri": "string",
  "code": "string",
  "refresh_token": "string",
  "dataType": "string",
  "callback": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» client_id|body|string| 是 |OAuth2客户ID|
|» client_secret|body|string| 是 |OAuth2密钥|
|» grant_type|body|string| 是 |授权方式：authorization_code或者refresh_token|
|» redirect_uri|body|string| 是 |回调地址|
|» code|body|string| 是 |调用 /action/oauth2/authorize 接口返回的授权码(grant_type为authorization_code时必选)|
|» refresh_token|body|string| 否 |上次调用 /action/oauth2/token 接口返回的refresh_token(grant_type为refresh_token时必选)|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|
|» callback|body|string| 否 |dataType为 jsonp 时用来指定回调函数|

> 返回示例

> 200 Response

```json
{
    "access_token": "8447ff97-9b8c-4224-9cec-63b97d34ba65",
    "refresh_token": "8447ff97-9b8c-4224-9cec",
    "token_type": "bearer",
    "expires_in": 43199,
    "uid": 12
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» access_token|string|true|none||access_token值|
|» refresh_token|string|true|none||refresh_token值|
|» token_type|string|true|none||access_token类型|
|» expires_in|integer|true|none||超时时间(单位秒)|
|» uid|integer|true|none||授权用户的uid|

# 个人信息

## POST openapi_user

POST /action/openapi/user

支持格式：JSON JSONP XML

HTTP请求方式：GET/POST

> Body 请求参数

```json
{
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

```json
{
    "id": "899",
    "email": "****@gmail.com",
    "name": "彭博",
    "gender": "male",
    "avatar": "http://www.oschina.net/uploads/user/****",
    "location": "广东 深圳",
    "url": "http://home.oschina.net/****"
}
```

```json
{
    "error": "invalid_token",
    "error_description": "Invalid access token: 7fade311-d844-4159-9890-c8f0511337e5"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» id|string|true|none||用户ID|
|» email|string|true|none||用户email|
|» name|string|true|none||用户名|
|» gender|string|true|none||性别|
|» avatar|string|true|none||头像|
|» location|string|true|none||地点|
|» url|string|true|none||主页|

## POST user_information

POST /action/openapi/user_information

> Body 请求参数

```json
{
  "access_token": "string",
  "user": "string",
  "friend": "string",
  "friend_name": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» user|body|string| 是 |查询用户id|
|» friend|body|string| 是 |被查询用户id（friend和friend_name必须存在一个）|
|» friend_name|body|string| 否 |被查询用户ident或名称|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "uid": 20,
    "name": "xxx",
    "ident": "xxx",
    "gender": 1,
    "relation": 3,
    "province": "上海",
    "city": "闵行",
    "platforms": [
        "Java EE",
        "PHP",
        ".NET/C#",
        "JavaScript",
        "Delphi/Pascal"
    ],
    "expertise": [
        "WEB开发",
        "服务器端开发",
        "DBA/数据库"
    ],
    "joinTime": "2008-09-18 09:17:15.0",
    "lastLoginTime": "2012-03-13 15:22:58.0",
    "portrait": "http://www.oschina.net/uploads/user/0/20_50.jpg",
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» uid|integer|true|none||被查询用户id|
|» name|string|true|none||用户名称|
|» ident|string|true|none||用户Ident|
|» gender|integer|true|none||性别：1-男，2-女|
|» relation|integer|true|none||关注情况：1-已关注（对方未关注我）2-相互关注 3-未关注|
|» province|string|true|none||省份|
|» city|string|true|none||城市|
|» platforms|[string]|true|none||开发平台|
|» expertise|[string]|true|none||专长领域|
|» joinTime|string|true|none||加入时间|
|» lastLoginTime|string|true|none||最近登录时间|
|» portrait|string|true|none||头像|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|

## POST my_information

POST /action/openapi/my_information

> Body 请求参数

```json
{
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "uid": 89964,
    "name": "彭博",
    "gender": 1,
    "province": "广东",
    "city": "深圳",
    "platforms": [
        "Java EE",
        "Java SE",
        "JavaScript",
        "HTML/CSS"
    ],
    "expertise": [
        "WEB开发",
        "桌面软件开发",
        "服务器端开发"
    ],
    "joinTime": "2010-07-14 17:15:55",
    "lastLoginTime": "2013-10-21 10:55:36",
    "portrait": "http://www.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000",
    "fansCount": 19,
    "favoriteCount": 176,
    "followersCount": 14,
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» uid|integer|true|none||被查询用户id|
|» name|string|true|none||用户名称|
|» gender|integer|true|none||性别：1-男，2-女|
|» province|string|true|none||省份|
|» city|string|true|none||城市|
|» platforms|[string]|true|none||开发平台|
|» expertise|[string]|true|none||专长领域|
|» joinTime|string|true|none||加入时间|
|» lastLoginTime|string|true|none||最近登录时间|
|» portrait|string|true|none||头像|
|» fansCount|integer|true|none||粉丝数|
|» favoriteCount|integer|true|none||收藏数|
|» followersCount|integer|true|none||关注数|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|

## POST portrait_update

POST /action/openapi/portrait_update

授权范围(scope)

更改用户信息

> Body 请求参数

```json
{
  "access_token": "string",
  "portrait": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» portrait|body|string| 是 |用户头像|

> 返回示例

> 200 Response

```json
{
    "error": "200",
    "error_description": "操作成功完成"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|string|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST friends_list

POST /action/openapi/friends_list

授权范围(scope)
访问用户信息

> Body 请求参数

```json
{
  "page/pageIndex": 0,
  "pageSize": 0,
  "relation": 0,
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» relation|body|integer| 是 |0-粉丝|1-关注的人|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "userList": [
        {
            "expertise": "<无>",
            "name": "test33",
            "userid": 253469,
            "gender": 1,
            "portrait": "http://static.oschina.org/uploads/user/126/253469_100.jpg?t=1366257509000"
        }
    ],
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» userList|[object]|true|none||用户ID|
|»» expertise|string|true|none||用户职业技能|
|»» name|string|true|none||用户名|
|»» userid|integer|false|none||none|
|»» gender|integer|true|none||性别 1-男|2-女|
|»» portrait|string|true|none||用户头像|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|

## POST active_list

POST /action/openapi/active_list

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问用户信息

> Body 请求参数

```json
{
  "access_token": "string",
  "catalog": 0,
  "user": 0,
  "pageSize": 0,
  "page/pageIndex": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 否 |oauth2_token获取的access_token catalog为4时不需要认证 其它都需要 否则提示失败|
|» catalog|body|integer| 否 |类别ID [ 0、1所有动态,2提到我的,3评论,4我自己 ]|
|» user|body|integer| 是 |用户ID|
|» pageSize|body|integer| 否 |每页条数|
|» page|body|integer| 否 |页数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "post_list": [
        {
            "id": 82977,
            "author": "彭博",
            "pubDate": "2012-12-18 16:20:08.0",
            "title": "测试youku视频地址",
            "answerCount": 0,
            "authorid": 89964,
            "answer": "",
            "portrait": "http://static.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000",
            "viewCount": 12
        },
        {
            "id": 83123,
            "author": "彭博",
            "pubDate": "2013-05-24 10:34:40.0",
            "title": "测试站外活动",
            "answerCount": 0,
            "authorid": 89964,
            "answer": "",
            "portrait": "http://static.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000",
            "viewCount": 0
        }
    ],
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» post_list|[object]|true|none||none|
|»» id|integer|true|none||动态ID|
|»» author|string|true|none||发布者|
|»» pubDate|string|true|none||pubDate|
|»» title|string|true|none||none|
|»» answerCount|integer|true|none||none|
|»» authorid|integer|true|none||发布者ID|
|»» answer|string|true|none||none|
|»» portrait|string|true|none||发布者用户头像地址|
|»» viewCount|integer|true|none||none|
|»» catalog|string|true|none||动态分类：1-新闻、2-问答区（发布帖子、回复帖子）、3-动弹、4-博客（发博客，评论）、0-其它|
|»» appClient|integer|true|none||客户端类型：1-WEB、2-WAP、3-Android、4-IOS、5-WP|
|»» objectId|integer|true|none||动态对象id：动弹 帖子 博客ID (根据objectType区分)|
|»» objectType|integer|true|none||动态类型：1-开源软件、2-帖子、3-博客、4-新闻、5-代码、6-职位、7-翻译文章、8-翻译段落、16-新闻评论、17-讨论区答案、18-博客评论、19-代码评论、20-职位评论、21-翻译评论、32-职位评论、100-动弹、101-动弹回复|
|»» objectCatalog|integer|true|none||动态对象分类：1-普通帖子（问答），2-城市圈活动，3-城市圈讨论，4-话题，5-对帖子评论的回复|
|»» objectTitle|string|true|none||动态对象标题(动弹为空 帖子,博客的标题)|
|»» objectReply|[object]|true|none||none|
|»»» objectName|string|true|none||动态对象回复者名称|
|»»» objectBody|string|true|none||动态对象回复内容|
|»» url|string|true|none||动态对象链接|
|»» message|string|true|none||动态对象内容|
|»» tweetImage|string|true|none||动弹图片，catalog 为 3 时（即为动弹时）才可能存在|
|»» commentCount|integer|true|none||评论数|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|

## POST update_user_relation

POST /action/openapi/update_user_relation

更新好友关系（加关注、取消关注）

是否需要登录
是
访问授权限制
password
授权范围(scope)
更改用户信息

> Body 请求参数

```json
{
  "access_token": "string",
  "friend": 0,
  "relation": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» friend|body|integer| 是 |对方用户id|
|» relation|body|integer| 是 |0-取消关注，1-加关注|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

```json
{
    "error": 200,
    "relation": 2,
    "error_description": "您已经对Ta添加关注"
}
```

```json
{
    "error": 500,
    "error_description": "非法请求参数"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|» relation|integer|true|none||1-互粉，2-已关注，3-未关注|
|» error_description|string|true|none||错误描述|

# 新闻

## POST news_list

POST /action/openapi/news_list

获取新闻列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问新闻资讯

> Body 请求参数

```json
{
  "access_token": "string",
  "catalog": 0,
  "page/pageIndex": 0,
  "pageSize": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» catalog|body|integer| 是 |1-所有|2-综合新闻|3-软件更新|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "newslist": [
        {
            "id": 26754,
            "author": "test33",
            "pubDate": "2013-09-17 16:49:50.0",
            "title": "asdfa",
            "authorid": 253469,
            "commentCount": 0,
            "type": 4
        }
    ],
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» newslist|[object]|true|none||none|
|»» id|integer|false|none||新闻id|
|»» author|string|false|none||投递者名称|
|»» pubDate|string|false|none||发布日期|
|»» title|string|false|none||新闻标题|
|»» authorid|integer|false|none||投递者编号|
|»» commentCount|integer|false|none||评论数|
|»» type|integer|false|none||新闻类型 [0-链接新闻|1-软件推荐|2-讨论区帖子|3-博客|4-普通新闻|7-翻译文章]|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» catalog|integer|true|none||[1-综合新闻|2-软件更新|3-所有]|
|» newsCount|integer|true|none||新闻条数|
|» pageSize|integer|true|none||每页条数|

## POST /action/openapi/news_detail

POST /action/openapi/news_detail

获取新闻详情

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问新闻资讯

> Body 请求参数

```json
{
  "id": "string",
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» id|body|string| 是 |新闻编号|
|» access_token|body|string| 否 |oauth2_token获取的access_token 传则显示是否收藏 用户未登录则不传|
|» dataType|body|string| 否 |返回数据类型 ['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "id": 11,
    "body": "语法高亮文本编辑器",
    "pubDate": "2008-09-15 17:00:29.0",
    "author": "总管",
    "title": "VirtualBox 2.0.2 released!",
    "authorid": 1,
    "relativies": [
        {
            "title": "RSyntaxTextArea 2.0.2 发布 语法高亮文本编辑器",
            "url": "http://liudong/news/26709/rsyntaxtextarea-2-0-2"
        },
        {
            "title": "Bootstrap 2.0.2 发布，Web 前端工具包",
            "url": "http://liudong/news/26688/bootstrap-2-0-2"
        },
        {
            "title": "Airtime 2.0.2 发布 - 电台管理系统",
            "url": "http://liudong/news/26516/airtime-202"
        },
        {
            "title": "Wayland and Weston 0.85.0 released",
            "url": "http://liudong/news/25610"
        },
        {
            "title": "jOOQ 2.0.2 发布，Java的ORM框架",
            "url": "http://liudong/news/24645/jooq-2-0-2-released"
        },
        {
            "title": "RemoteBox 1.2 发布，VirtualBox 管理工具",
            "url": "http://liudong/news/24463/remotebox-1-2-released"
        },
        {
            "title": "ChromePlus 2.0.0.4 Released(for Windows)",
            "url": "http://liudong/news/24457/chromeplus-2-0-0-4-for-windows"
        },
        {
            "title": "VirtualBox 4.1.8.75467 Final",
            "url": "http://liudong/news/24172/virtualbox-4-1-8-released"
        },
        {
            "title": "Spring Roo 1.2.0.RELEASED 发布",
            "url": "http://liudong/news/24114/spring-roo-1-2-0-released"
        },
        {
            "title": "MongoDB 2.0.2 发布",
            "url": "http://liudong/news/24076"
        }
    ],
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "favorite": 0,
    "commentCount": 0,
    "url": "http://liudong/news/11"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» id|integer|true|none||新闻编号|
|» body|string|true|none||新闻内容（HTML）|
|» pubDate|string|true|none||发布日期|
|» author|string|true|none||投递者编号|
|» title|string|true|none||新闻标题|
|» authorid|integer|true|none||none|
|» relativies|[object]|true|none||none|
|»» title|string|true|none||新闻标题|
|»» url|string|true|none||新闻原链接|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» favorite|integer|true|none||是否收藏 1-收藏 0-未收藏|
|» commentCount|integer|true|none||评论数|
|» url|string|true|none||新闻原地址|

# 帖子

## POST post_list

POST /action/openapi/post_list

获取讨论区的帖子列表(对应android的 问答 分享 综合 职业 站务)

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问帖子信息

> Body 请求参数

```json
{
  "access_token": "string",
  "catalog": 0,
  "tag": "string",
  "pageSize": 0,
  "page/pageIndex": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» catalog|body|integer| 否 |类别ID 1-问答 2-分享 3-IT杂烩(综合) 4-站务 100-职业生涯 0-所有|
|» tag|body|string| 否 |帖子相关标签|
|» pageSize|body|integer| 否 |每页条数|
|» page|body|integer| 否 |页数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "post_list": [
        {
            "id": 82977,
            "author": "彭博",
            "pubDate": "2012-12-18 16:20:08.0",
            "title": "测试youku视频地址",
            "answerCount": 0,
            "authorid": 89964,
            "answer": "",
            "portrait": "http://static.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000",
            "viewCount": 12
        },
        {
            "id": 83123,
            "author": "彭博",
            "pubDate": "2013-05-24 10:34:40.0",
            "title": "测试站外活动",
            "answerCount": 0,
            "authorid": 89964,
            "answer": "",
            "portrait": "http://static.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000",
            "viewCount": 0
        }
    ],
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» post_list|[object]|true|none||none|
|»» id|integer|true|none||帖子ID|
|»» author|string|true|none||发帖人|
|»» pubDate|string|true|none||发布时间|
|»» title|string|true|none||帖子标题|
|»» answerCount|integer|true|none||回复数|
|»» authorid|integer|true|none||发布者ID|
|»» answer|[object]|true|none||none|
|»»» time|string|true|none||最后回帖时间|
|»»» name|string|true|none||最后回帖用户|
|»» portrait|string|true|none||发帖人用户头像地址|
|»» viewCount|integer|true|none||浏览数|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|

## POST post_pub

POST /action/openapi/post_pub

发布帖子

是否需要登录
是
访问授权限制
暂无
授权范围(scope)
访问帖子信息

> Body 请求参数

```json
{
  "access_token": "string",
  "isNoticeMe": 0,
  "catalog": 0,
  "title": "string",
  "content": "string",
  "askuser": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» isNoticeMe|body|integer| 否 |有回答是否邮件通知 2是邮件通知|
|» catalog|body|integer| 是 |类别ID 1-问答 2-分享 3-IT杂烩(综合) 4-站务 100-职业生涯|
|» title|body|string| 是 |帖子标题|
|» content|body|string| 是 |帖子内容|
|» askuser|body|integer| 否 |用户id（向某人提问）|

> 返回示例

> 200 Response

```json
{
    "error": "200",
    "error_description": "操作成功完成"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|string|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST post_detail

POST /action/openapi/post_detail

获取讨论区的帖子详情

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问帖子信息

> Body 请求参数

```json
{
  "id": "string",
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» id|body|string| 是 |帖子ID|
|» access_token|body|string| 是 |oauth2_token获取的access_token 传则显示是否收藏|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "id": 121,
    "pubDate": "2009-02-24 23:47:54.0",
    "author": "红薯",
    "body": "04年1月写的一个在C语言中调用Java方法的小程序",
    "title": "04年1月写的一个在C语言中调用Java方法的小程序",
    "answerCount": 1,
    "authorid": 12,
    "viewCount": 441,
    "favorite": 1,
    "portrait": "http://static.oschina.net/uploads/user/0/12_50.jpg",
    "url": "http://liudong/question/12_121",
    "tags": [
        "C",
        "Java"
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» id|integer|true|none||帖子ID|
|» pubDate|string|true|none||发布时间|
|» author|string|true|none||发帖人|
|» body|string|true|none||帖子内容|
|» title|string|true|none||帖子标题|
|» answerCount|integer|true|none||回复数|
|» authorid|integer|true|none||发帖人ID|
|» viewCount|integer|true|none||浏览数|
|» favorite|integer|true|none||是否收藏 1-收藏 0-未收藏|
|» portrait|string|true|none||发帖人用户头像地址|
|» url|string|true|none||帖子链接|
|» tags|[string]|true|none||相关标签|

# 动弹

## POST tweet_list

POST /action/openapi/tweet_list

获取动弹列表 （最新动弹列表 我的动弹）

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问动弹信息

> Body 请求参数

```json
{
  "access_token": "string",
  "user": 0,
  "pageSize": 0,
  "page/pageIndex": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» user|body|integer| 否 |用户ID [ 0：最新动弹，-1：热门动弹，其它：我的动弹 ]|
|» pageSize|body|integer| 是 |每页条数|
|» page|body|integer| 否 |页数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "tweetlist": [
        {
            "id": 1121274,
            "pubDate": "2013-08-28 18:40:07.0",
            "body": "@做最好的三三",
            "author": "彭博",
            "authorid": 89964,
            "commentCount": 0,
            "portrait": "http://static.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000"
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» tweetlist|[object]|true|none||none|
|»» id|integer|false|none||动弹ID|
|»» pubDate|string|false|none||动弹时间|
|»» body|string|false|none||动弹内容|
|»» author|string|false|none||发帖人|
|»» authorid|integer|false|none||发帖人ID|
|»» commentCount|integer|false|none||评论数|
|»» portrait|string|false|none||发帖人用户头像地址|

## POST tweet_detail

POST /action/openapi/tweet_detail

获取动弹列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问动弹信息

> Body 请求参数

```json
{
  "access_token": "string",
  "id": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» id|body|integer| 是 |动弹ID|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "id": 1121274,
    "pubDate": "2013-08-28 18:40:07.0",
    "body": "@做最好的三三",
    "author": "彭博",
    "authorid": 89964,
    "imgBig": "http://static.oschina.net/img/hello-big.png",
    "imgSmall": "http://static.oschina.net/img/hello-small.png",
    "commentCount": 0,
    "portrait": "http://static.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» id|integer|true|none||动弹ID|
|» pubDate|string|true|none||动弹时间|
|» body|string|true|none||动弹内容|
|» author|string|true|none||发帖人|
|» authorid|integer|true|none||发帖人ID|
|» imgBig|string|true|none||动弹大图|
|» imgSmall|string|true|none||动弹小图|
|» commentCount|integer|true|none||评论数|
|» portrait|string|true|none||发帖人用户头像地址|

## POST tweet_pub

POST /action/openapi/tweet_pub

发布动弹

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问动弹信息

> Body 请求参数

```json
{
  "access_token": "string",
  "msg": "string",
  "img": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» msg|body|string| 是 |动弹内容|
|» img|body|integer| 否 |图片流|

> 返回示例

```json
{
    "error": 200,
    "error_description": "操作成功完成"
}
```

```json
{
    "error": 500,
    "error_description": "内容不能为空"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST tweet_delete

POST /action/openapi/tweet_delete

删除动弹

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问动弹信息

> Body 请求参数

```json
{
  "access_token": "string",
  "tweetid": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» tweetid|body|string| 是 |动弹对象id|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "error": {
        "code": 200,
        "msg": "操作成功完成"
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|object|true|none||none|
|»» code|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|»» msg|string|true|none||错误描述|

# 博客

## POST blog_pub

POST /action/openapi/blog_pub

发布博客

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "title": "string",
  "content": "string",
  "save_as_draft": 0,
  "catalog": "string",
  "abstracts": "string",
  "tags": "string",
  "classification": 0,
  "type": 0,
  "origin_url": "string",
  "privacy": "string",
  "deny_comment": "string",
  "auto_content": "string",
  "as_top": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» title|body|string| 是 |博客标题|
|» content|body|string| 是 |博客内容|
|» save_as_draft|body|integer| 否 |保存到草稿 是：1 否：0|
|» catalog|body|string| 否 |博客分类|
|» abstracts|body|string| 否 |博客摘要|
|» tags|body|string| 否 |博客标签，用逗号隔开|
|» classification|body|integer| 是 |系统博客分类|
|» type|body|integer| 否 |原创：1、转载：4|
|» origin_url|body|string| 否 |转载的原文链接|
|» privacy|body|string| 否 |公开：0、私有：1|
|» deny_comment|body|string| 否 |允许评论：0、禁止评论：1|
|» auto_content|body|string| 否 |自动生成目录：0、不自动生成目录：1|
|» as_top|body|string| 否 |非置顶：0、置顶：1|

> 返回示例

```json
{
    "error": 200,
    "error_description": "操作成功完成"
}
```

```json
{
    "error": 500,
    "error_description": "内容不能为空"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST blog_list

POST /action/openapi/blog_list

获取博客列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "page/pageIndex": 0,
  "pageSize": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "bloglist": [
        {
            "id": 49090,
            "pubDate": "2012-03-13 23:01:52.0",
            "author": "whxia320",
            "title": "mongodb for java使用中的小问题",
            "authorid": 100399,
            "type": 1,
            "commentCount": 7
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» bloglist|[object]|true|none||none|
|»» id|integer|false|none||博客id|
|»» pubDate|string|false|none||发布日期|
|»» author|string|false|none||投递者名称|
|»» title|string|false|none||博客标题|
|»» authorid|integer|false|none||投递者编号|
|»» type|integer|false|none||1-原创 4-转载|
|»» commentCount|integer|false|none||评论数|

## POST blog_recommend_list 

POST /action/openapi/blog_recommend_list

获取博客推荐列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "page/pageIndex": 0,
  "pageSize": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "bloglist": [
        {
            "id": 49090,
            "pubDate": "2012-03-13 23:01:52.0",
            "author": "whxia320",
            "title": "mongodb for java使用中的小问题",
            "authorid": 100399,
            "type": 1,
            "commentCount": 7
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» bloglist|[object]|true|none||none|
|»» id|integer|false|none||博客id|
|»» pubDate|string|false|none||发布日期|
|»» author|string|false|none||投递者名称|
|»» title|string|false|none||博客标题|
|»» authorid|integer|false|none||投递者编号|
|»» type|integer|false|none||1-原创 4-转载|
|»» commentCount|integer|false|none||评论数|

## POST blog_detail

POST /action/openapi/blog_detail

获取博客详情

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "id": 0,
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» id|body|integer| 是 |博客编号|
|» access_token|body|string| 否 |oauth2_token获取的access_token 传则显示是否收藏 用户未登录则不传|
|» dataType|body|string| 否 |返回数据类型 ['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "id": 49262,
    "body": "博客内容Demo",
    "pubDate": "2013-10-08 16:19:38.0",
    "author": "张艺辰",
    "title": "博客标题Demo",
    "authorid": 253479,
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "favorite": 0,
    "commentCount": 0,
    "url": "http://home.oschina.org/yidongnan/blog/49262"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» id|integer|true|none||博客编号|
|» body|string|true|none||博客内容（HTML）|
|» pubDate|string|true|none||发布日期|
|» author|string|true|none||none|
|» title|string|true|none||博客标题|
|» authorid|integer|true|none||投递者编号|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» favorite|integer|true|none||是否收藏 1-收藏 0-未收藏|
|» commentCount|integer|true|none||评论数|
|» url|string|true|none||博客地址|
|» relativies|[object]|true|none||none|
|»» title|string|true|none||新闻标题|
|»» url|string|true|none||新闻原链接|

## POST user_blog_list

POST /action/openapi/user_blog_list

获取用户博客列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "authoruid": 0,
  "authorname": "string",
  "page/pageIndex": 0,
  "pageSize": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 否 |oauth2_token获取的access_token 当提供的access_token和authoruid是同一用户则显示私有博客|
|» authoruid|body|integer| 否 |用户ID(authoruid authorname任选一种)|
|» authorname|body|string| 否 |用户Ident(authoruid authorname任选一种)|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "count": 111,
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "bloglist": [
        {
            "id": 49090,
            "pubDate": "2012-03-13 23:01:52.0",
            "author": "whxia320",
            "title": "mongodb for java使用中的小问题",
            "authorid": 100399,
            "type": 1,
            "commentCount": 7
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» count|integer|true|none||博客总数|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||none|
|»» msgCount|integer|true|none||none|
|»» fansCount|integer|true|none||none|
|»» referCount|integer|true|none||none|
|» bloglist|[object]|true|none||none|
|»» id|integer|false|none||博客id|
|»» pubDate|string|false|none||发布日期|
|»» author|string|false|none||投递者名称|
|»» title|string|false|none||博客标题|
|»» authorid|integer|false|none||投递者编号|
|»» type|integer|false|none||1-原创 4-转载|
|»» commentCount|integer|false|none||评论数|

## POST blog_catalog_list

POST /action/openapi/blog_catalog_list

获取博客分类列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "authoruid": 0,
  "authoruname": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» authoruid|body|integer| 是 |用户ID(authoruid authorname任选一种)|
|» authoruname|body|string| 是 |用户名(authoruid authorname任选一种)|

> 返回示例

> 200 Response

```json
{
    "blog_sys_catalog_list": [
        {
            "id": 122,
            "name": "asdf",
            "sort": 1
        }
    ],
    "blog_user_catalog_list": [
        {
            "id": 122,
            "name": "asdf",
            "sort": 1
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» blog_sys_catalog_list|[object]|true|none||none|
|»» id|integer|false|none||none|
|»» name|string|false|none||none|
|»» sort|integer|false|none||none|
|» blog_user_catalog_list|[object]|true|none||none|
|»» id|integer|false|none||分类id|
|»» name|string|false|none||分类名称|
|»» sort|integer|false|none||排列序号|

# 评论

## POST blog_comment_list

POST /action/openapi/blog_comment_list

获取博客评论列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "id": 0,
  "page/pageIndex": 0,
  "pageSize": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» id|body|integer| 是 |博客id|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "count": 11,
    "commentlist": [
        {
            "content": "alksdjf",
            "id": 276346713,
            "pubDate": "2013-10-14 14:53:56",
            "author": "彭博",
            "appClient": 2,
            "authorid": 89964,
            "portrait": "http://www.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000"
        },
        {
            "content": "alksdjf",
            "id": 276346609,
            "pubDate": "2013-10-14 14:45:14",
            "author": "彭博",
            "appClient": 2,
            "authorid": 89964,
            "refers": [
                {
                    "body": "alksdjf ",
                    "title": "引用来自“彭博”的评论"
                }
            ],
            "portrait": "http://www.oschina.net/uploads/user/44/89964_50.jpg?t=1376365607000"
        }
    ],
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» count|integer|true|none||none|
|» commentlist|[object]|true|none||none|
|»» content|string|true|none||评论内容|
|»» id|integer|true|none||评论ID|
|»» pubDate|string|true|none||发布日期|
|»» author|string|true|none||评论人姓名|
|»» appClient|integer|true|none||1-WEB、2-WAP、3-Android、4-IOS、5-WP|
|»» authorid|integer|true|none||评论人ID|
|»» portrait|string|true|none||评论人头像|
|»» refers|[object]|false|none||none|
|»»» body|string|false|none||评论中引用的内容|
|»»» title|string|false|none||评论中引用的标题|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||none|
|»» msgCount|integer|true|none||none|
|»» fansCount|integer|true|none||none|
|»» referCount|integer|true|none||none|

## POST blog_comment_pub

POST /action/openapi/blog_comment_pub

发表博客评论

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "blog": 0,
  "content": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» blog|body|integer| 是 |博客id|
|» content|body|string| 是 |回复内容|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

```json
{
    "error": "200",
    "error_description": "操作成功完成"
}
```

```json
{
    "error": "500",
    "error_description": "评论内容不能为空"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|string|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST blog_comment_reply

POST /action/openapi/blog_comment_reply

回复博客评论

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "blog": 0,
  "content": "string",
  "reply_id": 0,
  "reply_user": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» blog|body|integer| 是 |博客id|
|» content|body|string| 是 |回复内容|
|» reply_id|body|integer| 是 |被回复评论id|
|» reply_user|body|integer| 是 |被回复评论的发布者id|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

```json
{
    "error": "200",
    "error_description": "操作成功完成"
}
```

```json
{
    "error": "500",
    "error_description": "评论内容不能为空"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|string|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST user_blog_delete

POST /action/openapi/user_blog_delete

删除用户博客

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问博客信息

> Body 请求参数

```json
{
  "access_token": "string",
  "id": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» id|body|string| 是 |博客id|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "error": {
        "code": 200,
        "msg": "操作成功完成"
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|object|true|none||none|
|»» code|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|»» msg|string|true|none||错误描述|

## POST comment_list

POST /action/openapi/comment_list

获取评论列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问评论信息

注意事项

catalog为4的时候 查看私信列表必须提供access_token

> Body 请求参数

```json
{
  "id": "string",
  "catalog": "string",
  "access_token": "string",
  "page/pageIndex": "string",
  "pageSize": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» id|body|string| 是 |新闻ID/翻译ID/帖子ID/动弹ID/用户ID（私信中跟当前用户来往的ID）/博客ID|
|» catalog|body|string| 是 |1-新闻/翻译|2-帖子|3-动弹|4-消息(私信 必须access_token)|5-博客|
|» access_token|body|string| 否 |oauth2_token获取的access_token|
|» page|body|string| 否 |页数|
|» pageSize|body|string| 是 |每页条数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "commentList": [
        {
            "content": "引用来自“张艺辰”的答案发fdsfsafdasfdsafds",
            "id": 174745,
            "pubDate": "2013-10-09 15:24:28.0",
            "client_type": 1,
            "replies": [],
            "commentAuthor": "张艺辰",
            "commentAuthorId": 253479,
            "refers": [
                {
                    "refertitle": "引用来自“张艺辰”的答案",
                    "referbody": "发"
                }
            ]
        },
        {
            "content": "发",
            "id": 174742,
            "pubDate": "2013-10-09 10:39:07.0",
            "client_type": 1,
            "replies": [
                {
                    "rauthor": "张艺辰",
                    "rpubDate": "2013-10-09 10:39:07.0",
                    "rauthorId": 253479,
                    "rcontent": "发"
                }
            ],
            "commentAuthor": "张艺辰",
            "commentAuthorId": 253479
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||none|
|»» msgCount|integer|true|none||none|
|»» fansCount|integer|true|none||none|
|»» referCount|integer|true|none||none|
|» commentList|[object]|true|none||none|
|»» content|string|true|none||评论内容|
|»» id|integer|true|none||评论ID|
|»» pubDate|string|true|none||发布日期|
|»» client_type|integer|true|none||1-WEB、2-WAP、3-Android、4-IOS、5-WP|
|»» replies|[object]|true|none||none|
|»»» rauthor|string|false|none||帖子中评论 评论 的人|
|»»» rpubDate|string|false|none||帖子中评论 评论 的时间|
|»»» rauthorId|integer|false|none||帖子中评论 评论 的人的ID|
|»»» rcontent|string|false|none||帖子中评论 评论 的内容|
|»» commentAuthor|string|true|none||评论人|
|»» commentAuthorId|integer|true|none||评论人ID|
|»» commentPortrait|string|true|none||评论人头像|
|»» refers|[object]|false|none||none|
|»»» refertitle|string|false|none||评论中引用的标题|
|»»» referbody|string|false|none||评论中引用的内容|

## POST comment_pub

POST /action/openapi/comment_pub

发表评论

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问评论信息

> Body 请求参数

```json
{
  "access_token": "string",
  "catalog": 0,
  "id": 0,
  "content": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» catalog|body|integer| 是 |表示将对哪一种元素类型发表评论， 1 -- 新闻 2 -- 帖子 3 -- 动弹 4 -- 消息中心的消息|
|» id|body|integer| 是 |将要评论的id|
|» content|body|string| 是 |回复内容|

> 返回示例

```json
{
    "error": "200",
    "error_description": "操作成功完成"
}
```

```json
{
    "error": "500",
    "error_description": "评论内容不能为空"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|string|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST comment_reply

POST /action/openapi/comment_reply

回复评论

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问评论信息

注意事项
1、catalog = 1 时：id 大于 10000000 则为翻译，所需参数为：access_token，id，catalog，content，authorid，replyid
2、catalog = 2 时，所需参数：access_token，id，catalog，content
3、catalog = 3 时，所需参数：access_token，id，catalog，content，authorid
4、catalog = 4 时，所需参数：access_token，catalog，content，authorid此时 id 为非必须

> Body 请求参数

```json
{
  "access_token": "string",
  "id": 0,
  "catalog": 0,
  "content": "string",
  "receiver": 0,
  "authorid": 0,
  "replyid": 0,
  "isPostToMyZone": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» id|body|integer| 是 |回复对象id:新闻、翻译id，帖子id，动弹id|
|» catalog|body|integer| 是 |评论对象类型：1-新闻或翻译，2-帖子、问答，3-动弹，4-私信|
|» content|body|string| 是 |回复内容|
|» receiver|body|integer| 否 |被回复者id:要回复的此条评论的发布者的用户id|
|» authorid|body|integer| 否 |被回复者id:要回复的此条评论的发布者的用户id|
|» replyid|body|integer| 否 |被回复评论id:当前要回复的评论的id|
|» isPostToMyZone|body|integer| 否 |动弹是否转发到我的空间，1-转发，0-不转发。catalog 为 3 使用|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

```json
{
    "error": "200",
    "error_description": "操作成功完成"
}
```

```json
{
    "error": "500",
    "error_description": "评论内容不能为空"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|string|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST comment_delete

POST /action/openapi/comment_delete

删除评论

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问评论信息

注意事项
1、catalog = 1 时：id 大于 10000000 则为翻译，所需参数为：access_token，id，replyid
                             id小于10000000 则是新闻，所需参数为：access_token，id，replyid，authorid
2、catalog = 2 时，所需参数：access_token，id，authorid，replyid
3、catalog = 3 时，所需参数：access_token，id，replyid
4、catalog = 4 时，所需参数：access_token，id或replyid（id或replayid都为私信id）

> Body 请求参数

```json
{
  "access_token": "string",
  "catalog": 0,
  "id": 0,
  "replyid": 0,
  "authorid": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» catalog|body|integer| 是 |评论对象类型：1-新闻或翻译，2-帖子、问答，3-动弹，4-私信|
|» id|body|integer| 是 |对象id:新闻、翻译id，帖子id，动弹id|
|» replyid|body|integer| 是 |当前要回复的评论的id|
|» authorid|body|integer| 是 |回复的此条评论的发布者的用户id|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "error": {
        "code": 200,
        "msg": "操作成功完成"
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|object|true|none||none|
|»» code|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|»» msg|string|true|none||错误描述|

# 收藏

## POST favorite_list

POST /action/openapi/favorite_list

获取收藏列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问收藏信息

> Body 请求参数

```json
{
  "type": 0,
  "page/pageIndex": 0,
  "pageSize": 0,
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» type|body|integer| 是 |0-全部|1-软件|2-话题|3-博客|4-新闻|5代码|7-翻译|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "favoriteList": [
        {
            "title": "helloworld",
            "objid": 9688,
            "type": 5,
            "url": "http://oschina.org/code/snippet_253472_9688"
        },
        {
            "title": "JetBrains 开发工具商业授权全面六折！",
            "objid": 26745,
            "type": 4,
            "url": "http://oschina.org/news/26745"
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» favoriteList|[object]|true|none||none|
|»» title|string|true|none||标题|
|»» objid|integer|true|none||对应对象ID|
|»» type|integer|true|none||0-全部|1-软件|2-话题|3-博客|4-新闻|5代码|7-翻译|
|»» url|string|true|none||对应的url|

## POST favorite_add

POST /action/openapi/favorite_add

添加收藏

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问收藏信息

> Body 请求参数

```json
{
  "access_token": "string",
  "id": 0,
  "type": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» id|body|integer| 是 |被收藏对象id|
|» type|body|integer| 是 |被收藏对象类型 [1-软件,2-帖子（问答、话题）,3-博客,4-资讯,5-代码,7-翻译]|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "error": 200,
    "error_description": "操作成功完成"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

## POST favorite_remove

POST /action/openapi/favorite_remove

取消收藏

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问收藏信息

> Body 请求参数

```json
{
  "access_token": "string",
  "id": 0,
  "type": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» id|body|integer| 是 |被收藏对象id|
|» type|body|integer| 是 |被收藏对象类型 [1-软件,2-帖子（问答、话题）,3-博客,4-资讯,5-代码,7-翻译]|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "error": 200,
    "error_description": "操作成功完成"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

# 软件

## POST project_detail

POST /action/openapi/project_detail

获取软件详情

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问软件资讯
请求参数

> Body 请求参数

```json
{
  "ident": "string",
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» ident|body|string| 是 |软件Ident|
|» access_token|body|string| 是 |oauth2_token获取的access_token 传则显示是否收藏|
|» dataType|body|string| 否 |返回数据类型 ['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "body": "Android SDK 是 Android 的开发工具包。.......",
    "logo": "http://oschina.org/img/logo/android.png",
    "os": "Android",
    "download": "http://oschina.org/action/project/go?id=1089&p=download",
    "favorite": 0,
    "url": "http://oschina.org/p/android",
    "homepage": "http://oschina.org/action/project/go?id=1089&p=home",
    "id": 1089,
    "languages": "Java",
    "title": "Android SDK",
    "extensionTitle": "Android开发工具包",
    "document": "http://oschina.org/action/project/go?id=1089&p=doc",
    "recordtime": "2009-11-22 12:23:17.0",
    "license": "Apache"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» body|string|true|none||软件详情内容|
|» logo|string|true|none||软件logo地址|
|» os|string|true|none||软件操作系统|
|» download|string|true|none||软件下载链接|
|» favorite|integer|true|none||是否收藏 1-收藏 0-未收藏|
|» url|string|true|none||软件详情地址|
|» homepage|string|true|none||软件主页链接|
|» id|integer|true|none||软件编号|
|» languages|string|true|none||软件语言类型|
|» title|string|true|none||软件名称|
|» extensionTitle|string|true|none||软件详情页标题|
|» document|string|true|none||软件文档链接|
|» recordtime|string|true|none||登记时间|
|» license|string|true|none||软件类型|

## POST project_catalog_list

POST /action/openapi/project_catalog_list

获取软件分类列表(只有2级)

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问软件资讯

> Body 请求参数

```json
{
  "access_token": "string",
  "tag": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» tag|body|integer| 是 |,第一级:tag传0,第二级:传递第一级返回的对应tag|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "softwareTypes": [
        {
            "tag": 1,
            "name": "编程语言"
        },
        {
            "tag": 3,
            "name": "操作系统"
        },
        {
            "tag": 2,
            "name": "适应人员角色"
        }
    ],
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» softwareTypes|[object]|true|none||none|
|»» tag|integer|true|none||tag的ID|
|»» name|string|true|none||tag的name|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|

## POST project_list

POST /action/openapi/project_list

软件分类下的的软件列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问软件资讯

> Body 请求参数

```json
{
  "access_token": "string",
  "type": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» type|body|string| 是 |recommend-推荐|time-最新|view-热门|cn-国产|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "projectList": [
        {
            "description": "Android SDK",
            "name": "Android SDK",
            "url": "http://oschina.org/p/android"
        },
        {
            "description": "Spring",
            "name": "Spring",
            "url": "http://oschina.org/p/spring"
        },
        {
            "description": "CentOS",
            "name": "CentOS",
            "url": "http://oschina.org/p/centos"
        },
        {
            "description": "Nginx",
            "name": "Nginx",
            "url": "http://oschina.org/p/nginx"
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» projectList|[object]|true|none||none|
|»» description|string|true|none||软件描述|
|»» name|string|true|none||软件名|
|»» url|string|true|none||链接|
|» count|integer|true|none||该类型下的软件数|

## POST project_tag_list

POST /action/openapi/project_tag_list

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问软件资讯

注意事项
可以根据url提取出ident（项目唯一标识），然后根据action_openapi_project_detail中根据ident得到Project的详情

> Body 请求参数

```json
{
  "access_token": "string",
  "tag": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» tag|body|string| 是 |tagId，project_tag_list中的得到的tag|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "projectlist": [
        {
            "description": "Dart是一种基于类的可选类型化编程语言，...",
            "name": "Dart",
            "url": "http://oschina.org/p/dart"
        },
        {
            "description": "Python (发音:[ 'paiθ(ə)n; (US) 'pai...",
            "name": "Python",
            "url": "http://oschina.org/p/python"
        },
        {
            "description": "Go 已在Google公司内部测试过，但仍处于...",
            "name": "Go",
            "url": "http://oschina.org/p/go"
        },
        {
            "description": "Perl是一种脚本语言。 最初的设计者为拉...",
            "name": "Perl",
            "url": "http://oschina.org/p/perl"
        },
        {
            "description": "Ruby是一种跨平台、面向对象的动态类型编...",
            "name": "Ruby",
            "url": "http://oschina.org/p/ruby"
        }
    ],
    "count": 82
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» projectlist|[object]|true|none||none|
|»» description|string|true|none||软件描述|
|»» name|string|true|none||软件名|
|»» url|string|true|none||链接|
|» count|integer|true|none||该类型下的软件数|
|» notic|[object]|true|none||none|
|»» replyCount|string|true|none||未读评论数|
|»» msgCount|string|true|none||未读私信数|
|»» fansCount|string|true|none||新增粉丝数|
|»» referCount|string|true|none||未读@我数|

# 私信

## POST message_list

POST /action/openapi/message_list

获取私信列表

是否需要登录
否
访问授权限制
暂无
授权范围(scope)
访问私信信息

> Body 请求参数

```json
{
  "page/pageIndex": 0,
  "pageSize": 0,
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» page|body|integer| 否 |页数|
|» pageSize|body|integer| 是 |每页条数|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "notice": {
        "replyCount": 0,
        "msgCount": 0,
        "fansCount": 0,
        "referCount": 0
    },
    "messageList": [
        {
            "content": "你好啊",
            "senderid": 253479,
            "sender": "张艺辰",
            "friendid": 253469,
            "id": 898973,
            "pubDate": "2013-10-10 15:55:24.0",
            "friendname": "test33",
            "messageCount": 2,
            "portrait": "http://static.oschina.org/uploads/user/126/253469_50.jpg?t=1366257509000"
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» notice|object|true|none||none|
|»» replyCount|integer|true|none||未读评论数|
|»» msgCount|integer|true|none||未读私信数|
|»» fansCount|integer|true|none||新增粉丝数|
|»» referCount|integer|true|none||未读@我数|
|» messageList|[object]|true|none||none|
|»» content|string|false|none||私信内容|
|»» senderid|integer|false|none||发送者ID|
|»» sender|string|false|none||none|
|»» friendid|integer|false|none||接收人ID|
|»» id|integer|false|none||私信id|
|»» pubDate|string|false|none||私信发送日期|
|»» friendname|string|false|none||接收人用户名|
|»» messageCount|integer|false|none||来往私信数|
|»» portrait|string|false|none||私信人头像|
|»» sendername|string|true|none||发送者用户名|

## POST message_delete

POST /action/openapi/message_delete

删除私信

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问私信信息

> Body 请求参数

```json
{
  "access_token": "string",
  "user": 0,
  "friend": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» user|body|integer| 是 |发送私信者|
|» friend|body|integer| 是 |接受私信者|
|» dataType|body|string| 是 |返回值类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "error": {
        "code": 200,
        "msg": "操作成功完成"
    }
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|object|true|none||none|
|»» code|integer|true|none||错误代码（200-操作成功，500-操作失败）|
|»» msg|string|true|none||错误描述|

# 搜索

## POST search_list

POST /action/openapi/search_list

获取搜索列表

是否需要登录
否
访问授权限制
授权范围(scope)
访问搜索功能

> Body 请求参数

```json
{
  "access_token": "string",
  "catalog": "string",
  "q": "string",
  "pageSize": "string",
  "page/pageIndex": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» catalog|body|string| 是 |news-新闻，blog-博客，project-开源软件，post-帖子、问答|
|» q|body|string| 是 |搜索关键字|
|» pageSize|body|string| 是 |每页条数|
|» page|body|string| 否 |页数|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "searchlist": [
        {
            "id": 32171,
            "author": "viwii",
            "pubDate": "2011-09-15 07:32:51",
            "title": "硬盘安装linux mint 11（win7）",
            "name": "硬盘安装linux mint 11（win7）",
            "type": "blog",
            "url": "http://home.oschina.net/wxwHome/blog/32171"
        },
        {
            "id": 28647,
            "author": "jingshishengxu",
            "pubDate": "2011-07-23 15:39:01",
            "title": "mint 下安装google拼音输入法",
            "name": "mint 下安装google拼音输入法",
            "type": "blog",
            "url": "http://home.oschina.net/jingshishengxu/blog/28647"
        }
    ]
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» searchlist|[object]|true|none||none|
|»» id|integer|true|none||搜索对象id|
|»» author|string|true|none||作者/发者布|
|»» pubDate|string|true|none||发布时间|
|»» title|string|true|none||标题|
|»» name|string|true|none||名称|
|»» type|string|true|none||news-新闻，blog-博客，project-开源软件，post-帖子、问答|
|»» url|string|true|none||链接|

# 通知

## POST user_notice

POST /action/openapi/user_notice

获取用户通知

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问通知信息

> Body 请求参数

```json
{
  "access_token": "string",
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "replyCount": 0,
    "msgCount": 0,
    "fansCount": 3,
    "referCount": 5
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» replyCount|integer|true|none||新评论个数|
|» msgCount|integer|true|none||新私信个数|
|» fansCount|integer|true|none||新@我个数|
|» referCount|integer|true|none||新评论个数|

## POST clear_notice

POST /action/openapi/clear_notice

清除用户通知

是否需要登录
是
访问授权限制
password
授权范围(scope)
访问通知信息

> Body 请求参数

```json
{
  "access_token": "string",
  "type": 0,
  "dataType": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» access_token|body|string| 是 |oauth2_token获取的access_token|
|» type|body|integer| 是 |需清除的通知类型：1-清除 @我的信息(referCount)，2-清除 未读信息(msgCount)，3-清除 评论个数(replyCount)，4-清除 新粉丝个数(fansCount)|
|» dataType|body|string| 是 |返回数据类型['json'|'jsonp'|'xml']|

> 返回示例

> 200 Response

```json
{
    "error": "200",
    "error_description": "操作成功完成"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» error|string|true|none||错误代码（200-操作成功，500-操作失败）|
|» error_description|string|true|none||错误描述|

# 数据模型

