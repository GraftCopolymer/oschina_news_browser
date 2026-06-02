import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class UserInfo with _$UserInfo {
  const factory UserInfo({
    required int userId,
    required String username,
    required String avatar,
    required String email,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, Object?> json) => _$UserInfoFromJson(json);

}

@freezed
abstract class NewsSimple with _$NewsSimple {
  const factory NewsSimple({
    required int id,
    required String author,
    required String pubDate,
    required String title,
    required int commentCount,
    required String type,
  }) = _NewsSimple;

  factory NewsSimple.fromJson(Map<String, Object?> json) => _$NewsSimpleFromJson(json);
}

@freezed
abstract class NewsDetail with _$NewsDetail {
  const factory NewsDetail({
    required int id,
    required String body,
    required String pubDate,
    required String author,
    required String title,
    required int authorid,
  }) = _NewsDetail;

  factory NewsDetail.fromJson(Map<String, Object?> json) => _$NewsDetailFromJson(json);
}

@freezed
abstract class BlogSimple with _$BlogSimple {
  const factory BlogSimple({
    required int id,
    required String author,
    required String pubDate,
    required String title,
    required int authorid,
    required int commentCount,
    required int type,
    // 如果 Blog 需要额外字段，可以取消下方注释
    // String? body,
  }) = _BlogSimple;

  factory BlogSimple.fromJson(Map<String, Object?> json) => _$BlogSimpleFromJson(json);
}

@freezed
abstract class BlogDetail with _$BlogDetail {
  const factory BlogDetail({
    required int id,
    required String body,
    required String pubDate,
    required String author,
    required String title,
    required int authorid,
    // 提示：如果 Blog 接口返回了额外字段，例如评论数或分类，请在此添加：
    // required int commentCount,
  }) = _BlogDetail;

  factory BlogDetail.fromJson(Map<String, Object?> json) => _$BlogDetailFromJson(json);
}

@freezed
abstract class TokenModel with _$TokenModel {
  const factory TokenModel({
    // 用户 ID
    required String sub,
    // 过期时间戳
    required int exp,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, Object?> json) => _$TokenModelFromJson(json);
}
