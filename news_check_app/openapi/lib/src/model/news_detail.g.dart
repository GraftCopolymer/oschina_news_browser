// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NewsDetailFavoriteEnum _$newsDetailFavoriteEnum_number0 =
    const NewsDetailFavoriteEnum._('number0');
const NewsDetailFavoriteEnum _$newsDetailFavoriteEnum_number1 =
    const NewsDetailFavoriteEnum._('number1');

NewsDetailFavoriteEnum _$newsDetailFavoriteEnumValueOf(String name) {
  switch (name) {
    case 'number0':
      return _$newsDetailFavoriteEnum_number0;
    case 'number1':
      return _$newsDetailFavoriteEnum_number1;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NewsDetailFavoriteEnum> _$newsDetailFavoriteEnumValues =
    BuiltSet<NewsDetailFavoriteEnum>(const <NewsDetailFavoriteEnum>[
  _$newsDetailFavoriteEnum_number0,
  _$newsDetailFavoriteEnum_number1,
]);

Serializer<NewsDetailFavoriteEnum> _$newsDetailFavoriteEnumSerializer =
    _$NewsDetailFavoriteEnumSerializer();

class _$NewsDetailFavoriteEnumSerializer
    implements PrimitiveSerializer<NewsDetailFavoriteEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
  };

  @override
  final Iterable<Type> types = const <Type>[NewsDetailFavoriteEnum];
  @override
  final String wireName = 'NewsDetailFavoriteEnum';

  @override
  Object serialize(Serializers serializers, NewsDetailFavoriteEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NewsDetailFavoriteEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NewsDetailFavoriteEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NewsDetail extends NewsDetail {
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
  final NewsDetailFavoriteEnum? favorite;
  @override
  final int? commentCount;
  @override
  final BuiltList<RelatedItem>? relatedList;

  factory _$NewsDetail([void Function(NewsDetailBuilder)? updates]) =>
      (NewsDetailBuilder()..update(updates))._build();

  _$NewsDetail._(
      {this.id,
      this.title,
      this.author,
      this.authorId,
      this.publishTime,
      this.content,
      this.url,
      this.favorite,
      this.commentCount,
      this.relatedList})
      : super._();
  @override
  NewsDetail rebuild(void Function(NewsDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NewsDetailBuilder toBuilder() => NewsDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NewsDetail &&
        id == other.id &&
        title == other.title &&
        author == other.author &&
        authorId == other.authorId &&
        publishTime == other.publishTime &&
        content == other.content &&
        url == other.url &&
        favorite == other.favorite &&
        commentCount == other.commentCount &&
        relatedList == other.relatedList;
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
    _$hash = $jc(_$hash, relatedList.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NewsDetail')
          ..add('id', id)
          ..add('title', title)
          ..add('author', author)
          ..add('authorId', authorId)
          ..add('publishTime', publishTime)
          ..add('content', content)
          ..add('url', url)
          ..add('favorite', favorite)
          ..add('commentCount', commentCount)
          ..add('relatedList', relatedList))
        .toString();
  }
}

class NewsDetailBuilder implements Builder<NewsDetail, NewsDetailBuilder> {
  _$NewsDetail? _$v;

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

  NewsDetailFavoriteEnum? _favorite;
  NewsDetailFavoriteEnum? get favorite => _$this._favorite;
  set favorite(NewsDetailFavoriteEnum? favorite) => _$this._favorite = favorite;

  int? _commentCount;
  int? get commentCount => _$this._commentCount;
  set commentCount(int? commentCount) => _$this._commentCount = commentCount;

  ListBuilder<RelatedItem>? _relatedList;
  ListBuilder<RelatedItem> get relatedList =>
      _$this._relatedList ??= ListBuilder<RelatedItem>();
  set relatedList(ListBuilder<RelatedItem>? relatedList) =>
      _$this._relatedList = relatedList;

  NewsDetailBuilder() {
    NewsDetail._defaults(this);
  }

  NewsDetailBuilder get _$this {
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
      _relatedList = $v.relatedList?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NewsDetail other) {
    _$v = other as _$NewsDetail;
  }

  @override
  void update(void Function(NewsDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NewsDetail build() => _build();

  _$NewsDetail _build() {
    _$NewsDetail _$result;
    try {
      _$result = _$v ??
          _$NewsDetail._(
            id: id,
            title: title,
            author: author,
            authorId: authorId,
            publishTime: publishTime,
            content: content,
            url: url,
            favorite: favorite,
            commentCount: commentCount,
            relatedList: _relatedList?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'relatedList';
        _relatedList?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NewsDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
