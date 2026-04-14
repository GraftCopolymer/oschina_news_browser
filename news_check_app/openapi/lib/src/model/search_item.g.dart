// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchItemTypeEnum _$searchItemTypeEnum_news =
    const SearchItemTypeEnum._('news');
const SearchItemTypeEnum _$searchItemTypeEnum_blog =
    const SearchItemTypeEnum._('blog');
const SearchItemTypeEnum _$searchItemTypeEnum_project =
    const SearchItemTypeEnum._('project');
const SearchItemTypeEnum _$searchItemTypeEnum_post =
    const SearchItemTypeEnum._('post');

SearchItemTypeEnum _$searchItemTypeEnumValueOf(String name) {
  switch (name) {
    case 'news':
      return _$searchItemTypeEnum_news;
    case 'blog':
      return _$searchItemTypeEnum_blog;
    case 'project':
      return _$searchItemTypeEnum_project;
    case 'post':
      return _$searchItemTypeEnum_post;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchItemTypeEnum> _$searchItemTypeEnumValues =
    BuiltSet<SearchItemTypeEnum>(const <SearchItemTypeEnum>[
  _$searchItemTypeEnum_news,
  _$searchItemTypeEnum_blog,
  _$searchItemTypeEnum_project,
  _$searchItemTypeEnum_post,
]);

Serializer<SearchItemTypeEnum> _$searchItemTypeEnumSerializer =
    _$SearchItemTypeEnumSerializer();

class _$SearchItemTypeEnumSerializer
    implements PrimitiveSerializer<SearchItemTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'news': 'news',
    'blog': 'blog',
    'project': 'project',
    'post': 'post',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'news': 'news',
    'blog': 'blog',
    'project': 'project',
    'post': 'post',
  };

  @override
  final Iterable<Type> types = const <Type>[SearchItemTypeEnum];
  @override
  final String wireName = 'SearchItemTypeEnum';

  @override
  Object serialize(Serializers serializers, SearchItemTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchItemTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchItemTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchItem extends SearchItem {
  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? author;
  @override
  final DateTime? publishTime;
  @override
  final SearchItemTypeEnum? type;
  @override
  final String? url;

  factory _$SearchItem([void Function(SearchItemBuilder)? updates]) =>
      (SearchItemBuilder()..update(updates))._build();

  _$SearchItem._(
      {this.id, this.title, this.author, this.publishTime, this.type, this.url})
      : super._();
  @override
  SearchItem rebuild(void Function(SearchItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchItemBuilder toBuilder() => SearchItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchItem &&
        id == other.id &&
        title == other.title &&
        author == other.author &&
        publishTime == other.publishTime &&
        type == other.type &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, publishTime.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchItem')
          ..add('id', id)
          ..add('title', title)
          ..add('author', author)
          ..add('publishTime', publishTime)
          ..add('type', type)
          ..add('url', url))
        .toString();
  }
}

class SearchItemBuilder implements Builder<SearchItem, SearchItemBuilder> {
  _$SearchItem? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _author;
  String? get author => _$this._author;
  set author(String? author) => _$this._author = author;

  DateTime? _publishTime;
  DateTime? get publishTime => _$this._publishTime;
  set publishTime(DateTime? publishTime) => _$this._publishTime = publishTime;

  SearchItemTypeEnum? _type;
  SearchItemTypeEnum? get type => _$this._type;
  set type(SearchItemTypeEnum? type) => _$this._type = type;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  SearchItemBuilder() {
    SearchItem._defaults(this);
  }

  SearchItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _author = $v.author;
      _publishTime = $v.publishTime;
      _type = $v.type;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchItem other) {
    _$v = other as _$SearchItem;
  }

  @override
  void update(void Function(SearchItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchItem build() => _build();

  _$SearchItem _build() {
    final _$result = _$v ??
        _$SearchItem._(
          id: id,
          title: title,
          author: author,
          publishTime: publishTime,
          type: type,
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
