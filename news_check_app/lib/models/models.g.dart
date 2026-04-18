// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => _UserInfo(
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String,
  avatar: json['avatar'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UserInfoToJson(_UserInfo instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'avatar': instance.avatar,
  'email': instance.email,
};

_NewsSimple _$NewsSimpleFromJson(Map<String, dynamic> json) => _NewsSimple(
  id: (json['id'] as num).toInt(),
  author: json['author'] as String,
  pubDate: json['pubDate'] as String,
  title: json['title'] as String,
  authorid: (json['authorid'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  type: (json['type'] as num).toInt(),
);

Map<String, dynamic> _$NewsSimpleToJson(_NewsSimple instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'pubDate': instance.pubDate,
      'title': instance.title,
      'authorid': instance.authorid,
      'commentCount': instance.commentCount,
      'type': instance.type,
    };

_NewsDetail _$NewsDetailFromJson(Map<String, dynamic> json) => _NewsDetail(
  id: (json['id'] as num).toInt(),
  body: json['body'] as String,
  pubDate: json['pubDate'] as String,
  author: json['author'] as String,
  title: json['title'] as String,
  authorid: (json['authorid'] as num).toInt(),
);

Map<String, dynamic> _$NewsDetailToJson(_NewsDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'pubDate': instance.pubDate,
      'author': instance.author,
      'title': instance.title,
      'authorid': instance.authorid,
    };

_TokenModel _$TokenModelFromJson(Map<String, dynamic> json) =>
    _TokenModel(sub: json['sub'] as String, exp: (json['exp'] as num).toInt());

Map<String, dynamic> _$TokenModelToJson(_TokenModel instance) =>
    <String, dynamic>{'sub': instance.sub, 'exp': instance.exp};
