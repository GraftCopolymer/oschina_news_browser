// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserInfo {

 int get userId; String get username; String get avatar; String get email;
/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserInfoCopyWith<UserInfo> get copyWith => _$UserInfoCopyWithImpl<UserInfo>(this as UserInfo, _$identity);

  /// Serializes this UserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,avatar,email);

@override
String toString() {
  return 'UserInfo(userId: $userId, username: $username, avatar: $avatar, email: $email)';
}


}

/// @nodoc
abstract mixin class $UserInfoCopyWith<$Res>  {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) _then) = _$UserInfoCopyWithImpl;
@useResult
$Res call({
 int userId, String username, String avatar, String email
});




}
/// @nodoc
class _$UserInfoCopyWithImpl<$Res>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._self, this._then);

  final UserInfo _self;
  final $Res Function(UserInfo) _then;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? avatar = null,Object? email = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserInfo].
extension UserInfoPatterns on UserInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserInfo value)  $default,){
final _that = this;
switch (_that) {
case _UserInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _UserInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String username,  String avatar,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserInfo() when $default != null:
return $default(_that.userId,_that.username,_that.avatar,_that.email);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String username,  String avatar,  String email)  $default,) {final _that = this;
switch (_that) {
case _UserInfo():
return $default(_that.userId,_that.username,_that.avatar,_that.email);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String username,  String avatar,  String email)?  $default,) {final _that = this;
switch (_that) {
case _UserInfo() when $default != null:
return $default(_that.userId,_that.username,_that.avatar,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserInfo implements UserInfo {
  const _UserInfo({required this.userId, required this.username, required this.avatar, required this.email});
  factory _UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

@override final  int userId;
@override final  String username;
@override final  String avatar;
@override final  String email;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserInfoCopyWith<_UserInfo> get copyWith => __$UserInfoCopyWithImpl<_UserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,avatar,email);

@override
String toString() {
  return 'UserInfo(userId: $userId, username: $username, avatar: $avatar, email: $email)';
}


}

/// @nodoc
abstract mixin class _$UserInfoCopyWith<$Res> implements $UserInfoCopyWith<$Res> {
  factory _$UserInfoCopyWith(_UserInfo value, $Res Function(_UserInfo) _then) = __$UserInfoCopyWithImpl;
@override @useResult
$Res call({
 int userId, String username, String avatar, String email
});




}
/// @nodoc
class __$UserInfoCopyWithImpl<$Res>
    implements _$UserInfoCopyWith<$Res> {
  __$UserInfoCopyWithImpl(this._self, this._then);

  final _UserInfo _self;
  final $Res Function(_UserInfo) _then;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? avatar = null,Object? email = null,}) {
  return _then(_UserInfo(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$NewsSimple {

 int get id; String get author; String get pubDate; String get title; int get authorid; int get commentCount; int get type;
/// Create a copy of NewsSimple
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsSimpleCopyWith<NewsSimple> get copyWith => _$NewsSimpleCopyWithImpl<NewsSimple>(this as NewsSimple, _$identity);

  /// Serializes this NewsSimple to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsSimple&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorid, authorid) || other.authorid == authorid)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,pubDate,title,authorid,commentCount,type);

@override
String toString() {
  return 'NewsSimple(id: $id, author: $author, pubDate: $pubDate, title: $title, authorid: $authorid, commentCount: $commentCount, type: $type)';
}


}

/// @nodoc
abstract mixin class $NewsSimpleCopyWith<$Res>  {
  factory $NewsSimpleCopyWith(NewsSimple value, $Res Function(NewsSimple) _then) = _$NewsSimpleCopyWithImpl;
@useResult
$Res call({
 int id, String author, String pubDate, String title, int authorid, int commentCount, int type
});




}
/// @nodoc
class _$NewsSimpleCopyWithImpl<$Res>
    implements $NewsSimpleCopyWith<$Res> {
  _$NewsSimpleCopyWithImpl(this._self, this._then);

  final NewsSimple _self;
  final $Res Function(NewsSimple) _then;

/// Create a copy of NewsSimple
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? pubDate = null,Object? title = null,Object? authorid = null,Object? commentCount = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorid: null == authorid ? _self.authorid : authorid // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsSimple].
extension NewsSimplePatterns on NewsSimple {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsSimple value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsSimple() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsSimple value)  $default,){
final _that = this;
switch (_that) {
case _NewsSimple():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsSimple value)?  $default,){
final _that = this;
switch (_that) {
case _NewsSimple() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String author,  String pubDate,  String title,  int authorid,  int commentCount,  int type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsSimple() when $default != null:
return $default(_that.id,_that.author,_that.pubDate,_that.title,_that.authorid,_that.commentCount,_that.type);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String author,  String pubDate,  String title,  int authorid,  int commentCount,  int type)  $default,) {final _that = this;
switch (_that) {
case _NewsSimple():
return $default(_that.id,_that.author,_that.pubDate,_that.title,_that.authorid,_that.commentCount,_that.type);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String author,  String pubDate,  String title,  int authorid,  int commentCount,  int type)?  $default,) {final _that = this;
switch (_that) {
case _NewsSimple() when $default != null:
return $default(_that.id,_that.author,_that.pubDate,_that.title,_that.authorid,_that.commentCount,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsSimple implements NewsSimple {
  const _NewsSimple({required this.id, required this.author, required this.pubDate, required this.title, required this.authorid, required this.commentCount, required this.type});
  factory _NewsSimple.fromJson(Map<String, dynamic> json) => _$NewsSimpleFromJson(json);

@override final  int id;
@override final  String author;
@override final  String pubDate;
@override final  String title;
@override final  int authorid;
@override final  int commentCount;
@override final  int type;

/// Create a copy of NewsSimple
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsSimpleCopyWith<_NewsSimple> get copyWith => __$NewsSimpleCopyWithImpl<_NewsSimple>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsSimpleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsSimple&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorid, authorid) || other.authorid == authorid)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,author,pubDate,title,authorid,commentCount,type);

@override
String toString() {
  return 'NewsSimple(id: $id, author: $author, pubDate: $pubDate, title: $title, authorid: $authorid, commentCount: $commentCount, type: $type)';
}


}

/// @nodoc
abstract mixin class _$NewsSimpleCopyWith<$Res> implements $NewsSimpleCopyWith<$Res> {
  factory _$NewsSimpleCopyWith(_NewsSimple value, $Res Function(_NewsSimple) _then) = __$NewsSimpleCopyWithImpl;
@override @useResult
$Res call({
 int id, String author, String pubDate, String title, int authorid, int commentCount, int type
});




}
/// @nodoc
class __$NewsSimpleCopyWithImpl<$Res>
    implements _$NewsSimpleCopyWith<$Res> {
  __$NewsSimpleCopyWithImpl(this._self, this._then);

  final _NewsSimple _self;
  final $Res Function(_NewsSimple) _then;

/// Create a copy of NewsSimple
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? pubDate = null,Object? title = null,Object? authorid = null,Object? commentCount = null,Object? type = null,}) {
  return _then(_NewsSimple(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorid: null == authorid ? _self.authorid : authorid // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NewsDetail {

 int get id; String get body; String get pubDate; String get author; String get title; int get authorid;
/// Create a copy of NewsDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsDetailCopyWith<NewsDetail> get copyWith => _$NewsDetailCopyWithImpl<NewsDetail>(this as NewsDetail, _$identity);

  /// Serializes this NewsDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.author, author) || other.author == author)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorid, authorid) || other.authorid == authorid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,pubDate,author,title,authorid);

@override
String toString() {
  return 'NewsDetail(id: $id, body: $body, pubDate: $pubDate, author: $author, title: $title, authorid: $authorid)';
}


}

/// @nodoc
abstract mixin class $NewsDetailCopyWith<$Res>  {
  factory $NewsDetailCopyWith(NewsDetail value, $Res Function(NewsDetail) _then) = _$NewsDetailCopyWithImpl;
@useResult
$Res call({
 int id, String body, String pubDate, String author, String title, int authorid
});




}
/// @nodoc
class _$NewsDetailCopyWithImpl<$Res>
    implements $NewsDetailCopyWith<$Res> {
  _$NewsDetailCopyWithImpl(this._self, this._then);

  final NewsDetail _self;
  final $Res Function(NewsDetail) _then;

/// Create a copy of NewsDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? pubDate = null,Object? author = null,Object? title = null,Object? authorid = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorid: null == authorid ? _self.authorid : authorid // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsDetail].
extension NewsDetailPatterns on NewsDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsDetail value)  $default,){
final _that = this;
switch (_that) {
case _NewsDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsDetail value)?  $default,){
final _that = this;
switch (_that) {
case _NewsDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String body,  String pubDate,  String author,  String title,  int authorid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsDetail() when $default != null:
return $default(_that.id,_that.body,_that.pubDate,_that.author,_that.title,_that.authorid);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String body,  String pubDate,  String author,  String title,  int authorid)  $default,) {final _that = this;
switch (_that) {
case _NewsDetail():
return $default(_that.id,_that.body,_that.pubDate,_that.author,_that.title,_that.authorid);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String body,  String pubDate,  String author,  String title,  int authorid)?  $default,) {final _that = this;
switch (_that) {
case _NewsDetail() when $default != null:
return $default(_that.id,_that.body,_that.pubDate,_that.author,_that.title,_that.authorid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsDetail implements NewsDetail {
  const _NewsDetail({required this.id, required this.body, required this.pubDate, required this.author, required this.title, required this.authorid});
  factory _NewsDetail.fromJson(Map<String, dynamic> json) => _$NewsDetailFromJson(json);

@override final  int id;
@override final  String body;
@override final  String pubDate;
@override final  String author;
@override final  String title;
@override final  int authorid;

/// Create a copy of NewsDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsDetailCopyWith<_NewsDetail> get copyWith => __$NewsDetailCopyWithImpl<_NewsDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.author, author) || other.author == author)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorid, authorid) || other.authorid == authorid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,pubDate,author,title,authorid);

@override
String toString() {
  return 'NewsDetail(id: $id, body: $body, pubDate: $pubDate, author: $author, title: $title, authorid: $authorid)';
}


}

/// @nodoc
abstract mixin class _$NewsDetailCopyWith<$Res> implements $NewsDetailCopyWith<$Res> {
  factory _$NewsDetailCopyWith(_NewsDetail value, $Res Function(_NewsDetail) _then) = __$NewsDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String body, String pubDate, String author, String title, int authorid
});




}
/// @nodoc
class __$NewsDetailCopyWithImpl<$Res>
    implements _$NewsDetailCopyWith<$Res> {
  __$NewsDetailCopyWithImpl(this._self, this._then);

  final _NewsDetail _self;
  final $Res Function(_NewsDetail) _then;

/// Create a copy of NewsDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? pubDate = null,Object? author = null,Object? title = null,Object? authorid = null,}) {
  return _then(_NewsDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,pubDate: null == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorid: null == authorid ? _self.authorid : authorid // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
