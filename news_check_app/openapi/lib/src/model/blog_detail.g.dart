// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BlogDetailFavoriteEnum _$blogDetailFavoriteEnum_number0 =
    const BlogDetailFavoriteEnum._('number0');
const BlogDetailFavoriteEnum _$blogDetailFavoriteEnum_number1 =
    const BlogDetailFavoriteEnum._('number1');

BlogDetailFavoriteEnum _$blogDetailFavoriteEnumValueOf(String name) {
  switch (name) {
    case 'number0':
      return _$blogDetailFavoriteEnum_number0;
    case 'number1':
      return _$blogDetailFavoriteEnum_number1;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BlogDetailFavoriteEnum> _$blogDetailFavoriteEnumValues =
    BuiltSet<BlogDetailFavoriteEnum>(const <BlogDetailFavoriteEnum>[
  _$blogDetailFavoriteEnum_number0,
  _$blogDetailFavoriteEnum_number1,
]);

Serializer<BlogDetailFavoriteEnum> _$blogDetailFavoriteEnumSerializer =
    _$BlogDetailFavoriteEnumSerializer();

class _$BlogDetailFavoriteEnumSerializer
    implements PrimitiveSerializer<BlogDetailFavoriteEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
  };

  @override
  final Iterable<Type> types = const <Type>[BlogDetailFavoriteEnum];
  @override
  final String wireName = 'BlogDetailFavoriteEnum';

  @override
  Object serialize(Serializers serializers, BlogDetailFavoriteEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BlogDetailFavoriteEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BlogDetailFavoriteEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BlogDetail extends BlogDetail {
  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? author;
  @override
  final int? authorId;
  @override
  final DateTime? publishTime;
  @override
  final String? content;
  @override
  final String? url;
  @override
  final BlogDetailFavoriteEnum? favorite;
  @override
  final int? commentCount;

  factory _$BlogDetail([void Function(BlogDetailBuilder)? updates]) =>
      (BlogDetailBuilder()..update(updates))._build();

  _$BlogDetail._(
      {this.id,
      this.title,
      this.author,
      this.authorId,
      this.publishTime,
      this.content,
      this.url,
      this.favorite,
      this.commentCount})
      : super._();
  @override
  BlogDetail rebuild(void Function(BlogDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlogDetailBuilder toBuilder() => BlogDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlogDetail &&
        id == other.id &&
        title == other.title &&
        author == other.author &&
        authorId == other.authorId &&
        publishTime == other.publishTime &&
        content == other.content &&
        url == other.url &&
        favorite == other.favorite &&
        commentCount == other.commentCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, authorId.hashCode);
    _$hash = $jc(_$hash, publishTime.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, favorite.hashCode);
    _$hash = $jc(_$hash, commentCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlogDetail')
          ..add('id', id)
          ..add('title', title)
          ..add('author', author)
          ..add('authorId', authorId)
          ..add('publishTime', publishTime)
          ..add('content', content)
          ..add('url', url)
          ..add('favorite', favorite)
          ..add('commentCount', commentCount))
        .toString();
  }
}

class BlogDetailBuilder implements Builder<BlogDetail, BlogDetailBuilder> {
  _$BlogDetail? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _author;
  String? get author => _$this._author;
  set author(String? author) => _$this._author = author;

  int? _authorId;
  int? get authorId => _$this._authorId;
  set authorId(int? authorId) => _$this._authorId = authorId;

  DateTime? _publishTime;
  DateTime? get publishTime => _$this._publishTime;
  set publishTime(DateTime? publishTime) => _$this._publishTime = publishTime;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  BlogDetailFavoriteEnum? _favorite;
  BlogDetailFavoriteEnum? get favorite => _$this._favorite;
  set favorite(BlogDetailFavoriteEnum? favorite) => _$this._favorite = favorite;

  int? _commentCount;
  int? get commentCount => _$this._commentCount;
  set commentCount(int? commentCount) => _$this._commentCount = commentCount;

  BlogDetailBuilder() {
    BlogDetail._defaults(this);
  }

  BlogDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _author = $v.author;
      _authorId = $v.authorId;
      _publishTime = $v.publishTime;
      _content = $v.content;
      _url = $v.url;
      _favorite = $v.favorite;
      _commentCount = $v.commentCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlogDetail other) {
    _$v = other as _$BlogDetail;
  }

  @override
  void update(void Function(BlogDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlogDetail build() => _build();

  _$BlogDetail _build() {
    final _$result = _$v ??
        _$BlogDetail._(
          id: id,
          title: title,
          author: author,
          authorId: authorId,
          publishTime: publishTime,
          content: content,
          url: url,
          favorite: favorite,
          commentCount: commentCount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
