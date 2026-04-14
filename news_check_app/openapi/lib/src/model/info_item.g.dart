// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InfoItemTypeEnum _$infoItemTypeEnum_news =
    const InfoItemTypeEnum._('news');
const InfoItemTypeEnum _$infoItemTypeEnum_blog =
    const InfoItemTypeEnum._('blog');

InfoItemTypeEnum _$infoItemTypeEnumValueOf(String name) {
  switch (name) {
    case 'news':
      return _$infoItemTypeEnum_news;
    case 'blog':
      return _$infoItemTypeEnum_blog;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InfoItemTypeEnum> _$infoItemTypeEnumValues =
    BuiltSet<InfoItemTypeEnum>(const <InfoItemTypeEnum>[
  _$infoItemTypeEnum_news,
  _$infoItemTypeEnum_blog,
]);

Serializer<InfoItemTypeEnum> _$infoItemTypeEnumSerializer =
    _$InfoItemTypeEnumSerializer();

class _$InfoItemTypeEnumSerializer
    implements PrimitiveSerializer<InfoItemTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'news': 'news',
    'blog': 'blog',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'news': 'news',
    'blog': 'blog',
  };

  @override
  final Iterable<Type> types = const <Type>[InfoItemTypeEnum];
  @override
  final String wireName = 'InfoItemTypeEnum';

  @override
  Object serialize(Serializers serializers, InfoItemTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InfoItemTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InfoItemTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InfoItem extends InfoItem {
  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? author;
  @override
  final DateTime? publishTime;
  @override
  final String? thumbnail;
  @override
  final int? viewCount;
  @override
  final int? commentCount;
  @override
  final InfoItemTypeEnum? type;

  factory _$InfoItem([void Function(InfoItemBuilder)? updates]) =>
      (InfoItemBuilder()..update(updates))._build();

  _$InfoItem._(
      {this.id,
      this.title,
      this.author,
      this.publishTime,
      this.thumbnail,
      this.viewCount,
      this.commentCount,
      this.type})
      : super._();
  @override
  InfoItem rebuild(void Function(InfoItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InfoItemBuilder toBuilder() => InfoItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InfoItem &&
        id == other.id &&
        title == other.title &&
        author == other.author &&
        publishTime == other.publishTime &&
        thumbnail == other.thumbnail &&
        viewCount == other.viewCount &&
        commentCount == other.commentCount &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, publishTime.hashCode);
    _$hash = $jc(_$hash, thumbnail.hashCode);
    _$hash = $jc(_$hash, viewCount.hashCode);
    _$hash = $jc(_$hash, commentCount.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InfoItem')
          ..add('id', id)
          ..add('title', title)
          ..add('author', author)
          ..add('publishTime', publishTime)
          ..add('thumbnail', thumbnail)
          ..add('viewCount', viewCount)
          ..add('commentCount', commentCount)
          ..add('type', type))
        .toString();
  }
}

class InfoItemBuilder implements Builder<InfoItem, InfoItemBuilder> {
  _$InfoItem? _$v;

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

  String? _thumbnail;
  String? get thumbnail => _$this._thumbnail;
  set thumbnail(String? thumbnail) => _$this._thumbnail = thumbnail;

  int? _viewCount;
  int? get viewCount => _$this._viewCount;
  set viewCount(int? viewCount) => _$this._viewCount = viewCount;

  int? _commentCount;
  int? get commentCount => _$this._commentCount;
  set commentCount(int? commentCount) => _$this._commentCount = commentCount;

  InfoItemTypeEnum? _type;
  InfoItemTypeEnum? get type => _$this._type;
  set type(InfoItemTypeEnum? type) => _$this._type = type;

  InfoItemBuilder() {
    InfoItem._defaults(this);
  }

  InfoItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _author = $v.author;
      _publishTime = $v.publishTime;
      _thumbnail = $v.thumbnail;
      _viewCount = $v.viewCount;
      _commentCount = $v.commentCount;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InfoItem other) {
    _$v = other as _$InfoItem;
  }

  @override
  void update(void Function(InfoItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InfoItem build() => _build();

  _$InfoItem _build() {
    final _$result = _$v ??
        _$InfoItem._(
          id: id,
          title: title,
          author: author,
          publishTime: publishTime,
          thumbnail: thumbnail,
          viewCount: viewCount,
          commentCount: commentCount,
          type: type,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
